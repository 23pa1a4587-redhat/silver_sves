import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/utils/employee_id_generator.dart';
import '../../../../core/utils/id_generator_util.dart';
import '../../../../core/utils/user_id_generator.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

/// Firebase implementation of UserRepository for admin operations
class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;

  FirebaseUserRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      // Generate role-specific ID (will be set when we have Firebase UID)
      // For now, use Firestore auto-generated ID
      final collectionName = UserIdGenerator.getCollectionForRole(user.role);
      final collectionRef = _firestore.collection(collectionName);

      // Create document with auto-generated ID first
      final tempDocRef = collectionRef.doc();
      final roleDocId = UserIdGenerator.generateUserId(
        user.role,
        tempDocRef.id,
      );

      // Now create with the prefixed ID
      final docRef = collectionRef.doc(roleDocId);

      // Generate permanent employee ID from the raw Firebase UUID with 'emp_' prefix
      final employeeId = IdGeneratorUtil.generateEmployeeId(tempDocRef.id);

      final userData = user
          .copyWith(
            id: roleDocId,
            employeeId: employeeId, // Set permanent shortened employee ID
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          )
          .toJson();

      // Create full user profile in role-specific collection
      await docRef.set(userData);

      final createdUser = user.copyWith(
        id: roleDocId,
        employeeId: employeeId, // Include in returned user
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Create auth lookup record in users collection
      await _firestore.collection(FirebaseConstants.usersCollection).add({
        'phone': user.phone,
        'role': _getRoleString(user.role),
        'roleDocId': roleDocId,
        'isActive': user.isActive,
        'lastUsed': FieldValue.serverTimestamp(),
      });

      // Update department statistics if user has a department
      if (user.departmentId != null) {
        await _updateDepartmentOnUserCreate(user.departmentId!, createdUser);
      }

      return createdUser;
    } catch (e) {
      throw Exception('Failed to create user: ${e.toString()}');
    }
  }

  @override
  Stream<List<UserModel>> getUsers({
    bool activeOnly = false,
    UserRole? role,
    String? departmentId,
  }) {
    try {
      // If role is specified, query only that role's collection
      if (role != null) {
        return _getUsersFromCollection(
          UserIdGenerator.getCollectionForRole(role),
          activeOnly: activeOnly,
          departmentId: departmentId,
        );
      }

      // Otherwise, merge streams from all role collections
      return _getAllUsersFromAllCollections(
        activeOnly: activeOnly,
        departmentId: departmentId,
      );
    } catch (e) {
      throw Exception('Failed to get employee users: ${e.toString()}');
    }
  }

  /// Get all users in a specific department

  // Helper: Get users from a specific collection
  Stream<List<UserModel>> _getUsersFromCollection(
    String collectionName, {
    bool activeOnly = false,
    String? departmentId,
  }) {
    Query query = _firestore.collection(collectionName);

    if (activeOnly) {
      query = query.where('isActive', isEqualTo: true);
    }

    if (departmentId != null) {
      query = query.where('departmentId', isEqualTo: departmentId);
    }

    return query.snapshots().map((snapshot) {
      final users = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson({...data, 'id': doc.id});
      }).toList();

      // Sort by name
      users.sort((a, b) => a.name.compareTo(b.name));
      return users;
    });
  }

  // Helper: Merge streams from all role collections
  Stream<List<UserModel>> _getAllUsersFromAllCollections({
    bool activeOnly = false,
    String? departmentId,
  }) {
    final superAdminStream = _getUsersFromCollection(
      FirebaseConstants.superAdminsCollection,
      activeOnly: activeOnly,
      departmentId: departmentId,
    );
    final deptHeadStream = _getUsersFromCollection(
      FirebaseConstants.departmentHeadsCollection,
      activeOnly: activeOnly,
      departmentId: departmentId,
    );
    final employeeStream = _getUsersFromCollection(
      FirebaseConstants.employeesCollection,
      activeOnly: activeOnly,
      departmentId: departmentId,
    );

    // Combine all three streams
    return superAdminStream.asyncExpand((superAdmins) {
      return deptHeadStream.asyncExpand((deptHeads) {
        return employeeStream.map((employees) {
          final allUsers = [...superAdmins, ...deptHeads, ...employees];
          allUsers.sort((a, b) => a.name.compareTo(b.name));
          return allUsers;
        });
      });
    });
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    try {
      // Since all users have 'emp_' prefix, search all collections
      return await _searchUserInAllCollections(id);
    } catch (e) {
      throw Exception('Failed to get user: ${e.toString()}');
    }
  }

  // Helper: Search for user by ID in all collections
  Future<UserModel?> _searchUserInAllCollections(String id) async {
    for (final collection in [
      FirebaseConstants.superAdminsCollection,
      FirebaseConstants.departmentHeadsCollection,
      FirebaseConstants.employeesCollection,
    ]) {
      final doc = await _firestore.collection(collection).doc(id).get();
      if (doc.exists) {
        final data = doc.data()!;
        return UserModel.fromJson({...data, 'id': doc.id});
      }
    }
    return null;
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final Set<String> seenIds = {};
      final List<UserModel> users = [];

      // Search across all three role collections
      for (final collection in [
        FirebaseConstants.superAdminsCollection,
        FirebaseConstants.departmentHeadsCollection,
        FirebaseConstants.employeesCollection,
      ]) {
        // Search by name
        final nameQuery = await _firestore
            .collection(collection)
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThan: query + 'z')
            .get();

        // Search by employee ID
        final empIdQuery = await _firestore
            .collection(collection)
            .where('employeeId', isGreaterThanOrEqualTo: query.toUpperCase())
            .where('employeeId', isLessThan: query.toUpperCase() + 'Z')
            .get();

        // Search by phone
        final phoneQuery = await _firestore
            .collection(collection)
            .where('phone', isGreaterThanOrEqualTo: query)
            .where('phone', isLessThan: query + 'z')
            .get();

        // Add results from this collection
        for (final doc in [
          ...nameQuery.docs,
          ...empIdQuery.docs,
          ...phoneQuery.docs,
        ]) {
          if (!seenIds.contains(doc.id)) {
            seenIds.add(doc.id);
            final data = doc.data();
            users.add(UserModel.fromJson({...data, 'id': doc.id}));
          }
        }
      }

      return users;
    } catch (e) {
      throw Exception('Failed to search users: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      // Search for user in all collections since all have emp_ prefix
      UserModel? oldUser;
      String? oldCollectionName;

      for (final collection in [
        FirebaseConstants.superAdminsCollection,
        FirebaseConstants.departmentHeadsCollection,
        FirebaseConstants.employeesCollection,
      ]) {
        final doc = await _firestore.collection(collection).doc(user.id).get();
        if (doc.exists) {
          oldUser = UserModel.fromJson({...doc.data()!, 'id': doc.id});
          oldCollectionName = collection;
          break;
        }
      }

      if (oldUser == null || oldCollectionName == null) {
        throw Exception('User not found in any collection');
      }

      // Check for role change (requires migration between collections)
      if (oldUser.role != user.role) {
        await _handleRoleChange(oldUser, user);
        return;
      }

      // Track department transfer if department changed
      if (oldUser.departmentId != user.departmentId) {
        // Track employee_transferred_out in OLD department
        // Track employee_transferred_in in NEW department
      }

      // Update department statistics if needed
      await _updateDepartmentOnUserUpdate(oldUser, user);

      // Check if phone changed (need to update auth lookup)
      if (oldUser.phone != user.phone) {
        await _updateAuthLookupPhone(oldUser.phone, user.phone);
      }

      final userData = user.copyWith(updatedAt: DateTime.now()).toJson();

      // Update in the correct collection
      await _firestore
          .collection(oldCollectionName)
          .doc(user.id)
          .update(userData);

      // Update auth lookup if active status changed
      await _updateAuthLookupStatus(user.phone, user.isActive);
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
  }

  @override
  Future<void> deactivateUser(String userId) async {
    try {
      final user = await getUserById(userId);
      if (user == null) throw Exception('User not found');

      final collectionName = user.getCollectionName();

      // Update role-specific collection
      await _firestore.collection(collectionName).doc(userId).update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update auth lookup
      await _updateAuthLookupStatus(user.phone, false);

      // Track employee deactivation in department history
    } catch (e) {
      throw Exception('Failed to deactivate user: ${e.toString()}');
    }
  }

  @override
  Future<void> activateUser(String userId) async {
    try {
      final user = await getUserById(userId);
      if (user == null) throw Exception('User not found');

      final collectionName = user.getCollectionName();

      // Update role-specific collection
      await _firestore.collection(collectionName).doc(userId).update({
        'isActive': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update auth lookup
      await _updateAuthLookupStatus(user.phone, true);
    } catch (e) {
      throw Exception('Failed to activate user: ${e.toString()}');
    }
  }

  @override
  Future<bool> isPhoneUnique(String phone, {String? excludeId}) async {
    try {
      final query = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .where('phone', isEqualTo: phone)
          .get();

      if (query.docs.isEmpty) return true;

      // If excluding an ID (for updates), check if the phone belongs to the user
      if (excludeId != null) {
        // The phone is unique if all found records belong to the user being edited
        // This handles role changes where the roleDocId might have changed
        return query.docs.length == 1 &&
            query.docs.first.data()['roleDocId'] == excludeId;
      }

      return false;
    } catch (e) {
      throw Exception('Failed to check phone uniqueness: ${e.toString()}');
    }
  }

  @override
  Future<int> getUserCount({bool activeOnly = true}) async {
    try {
      int totalCount = 0;

      // Count users from all three role-specific collections
      for (final collection in [
        FirebaseConstants.superAdminsCollection,
        FirebaseConstants.departmentHeadsCollection,
        FirebaseConstants.employeesCollection,
      ]) {
        Query query = _firestore.collection(collection);

        if (activeOnly) {
          query = query.where('isActive', isEqualTo: true);
        }

        final snapshot = await query.count().get();
        totalCount += snapshot.count ?? 0;
      }

      return totalCount;
    } catch (e) {
      throw Exception('Failed to get user count: ${e.toString()}');
    }
  }

  @override
  Future<Map<UserRole, int>> getUserCountByRole({
    bool activeOnly = true,
  }) async {
    try {
      final Map<UserRole, int> counts = {
        UserRole.superAdmin: 0,
        UserRole.departmentHead: 0,
        UserRole.employee: 0,
      };

      // Count from each role-specific collection
      for (final role in UserRole.values) {
        final collection = UserIdGenerator.getCollectionForRole(role);
        Query query = _firestore.collection(collection);

        if (activeOnly) {
          query = query.where('isActive', isEqualTo: true);
        }

        final snapshot = await query.count().get();
        counts[role] = snapshot.count ?? 0;
      }

      return counts;
    } catch (e) {
      throw Exception('Failed to get user count by role: ${e.toString()}');
    }
  }

  @override
  Future<List<UserModel>> getUsersByDepartment(
    String departmentId, {
    bool activeOnly = true,
  }) async {
    try {
      final List<UserModel> allUsers = [];

      // Query all three role collections
      for (final collection in [
        FirebaseConstants.superAdminsCollection,
        FirebaseConstants.departmentHeadsCollection,
        FirebaseConstants.employeesCollection,
      ]) {
        Query query = _firestore
            .collection(collection)
            .where('departmentId', isEqualTo: departmentId);

        if (activeOnly) {
          query = query.where('isActive', isEqualTo: true);
        }

        final snapshot = await query.get();
        allUsers.addAll(
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return UserModel.fromJson({...data, 'id': doc.id});
          }),
        );
      }

      return allUsers;
    } catch (e) {
      throw Exception('Failed to get users by department: ${e.toString()}');
    }
  }

  // Helper to convert UserRole enum to string
  String _getRoleString(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'super_admin';
      case UserRole.departmentHead:
        return 'department_head';
      case UserRole.employee:
        return 'employee';
    }
  }

  // Helper: Update auth lookup phone number
  Future<void> _updateAuthLookupPhone(String oldPhone, String newPhone) async {
    try {
      final authSnapshot = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .where('phone', isEqualTo: oldPhone)
          .limit(1)
          .get();

      if (authSnapshot.docs.isNotEmpty) {
        await authSnapshot.docs.first.reference.update({'phone': newPhone});
      }
    } catch (e) {
      throw Exception('Failed to update auth lookup phone: ${e.toString()}');
    }
  }

  // Helper: Update auth lookup active status
  Future<void> _updateAuthLookupStatus(String phone, bool isActive) async {
    try {
      final authSnapshot = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();

      if (authSnapshot.docs.isNotEmpty) {
        await authSnapshot.docs.first.reference.update({'isActive': isActive});
      }
    } catch (e) {
      throw Exception('Failed to update auth lookup status: ${e.toString()}');
    }
  }

  // Helper: Handle role change (migrate between collections)
  Future<void> _handleRoleChange(UserModel oldUser, UserModel newUser) async {
    try {
      final oldCollection = oldUser.getCollectionName();
      final newCollection = newUser.getCollectionName();

      // Generate new ID for new role
      final uid = UserIdGenerator.extractUidFromUserId(oldUser.id);
      final newId = UserIdGenerator.generateUserId(newUser.role, uid);

      // Employee ID stays the same - it's permanent!
      final updatedUser = newUser.copyWith(
        id: newId,
        updatedAt: DateTime.now(),
      );

      // Create in new collection
      await _firestore
          .collection(newCollection)
          .doc(newId)
          .set(updatedUser.toJson());

      // Update auth lookup
      final authSnapshot = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .where('phone', isEqualTo: oldUser.phone)
          .limit(1)
          .get();

      if (authSnapshot.docs.isNotEmpty) {
        await authSnapshot.docs.first.reference.update({
          'role': _getRoleString(newUser.role),
          'roleDocId': newId,
        });
      }

      // Delete from old collection
      await _firestore.collection(oldCollection).doc(oldUser.id).delete();

      // Update department statistics
      await _updateDepartmentOnUserUpdate(oldUser, updatedUser);
    } catch (e) {
      throw Exception('Failed to handle role change: ${e.toString()}');
    }
  }

  // Update department when user is created
  Future<void> _updateDepartmentOnUserCreate(
    String departmentId,
    UserModel user,
  ) async {
    final deptRef = _firestore
        .collection(FirebaseConstants.departmentsCollection)
        .doc(departmentId);

    // Increment employee count
    await deptRef.update({'employee_count': FieldValue.increment(1)});

    // If user is department head, set head info
    if (user.role == UserRole.departmentHead) {
      await deptRef.update({'head_id': user.id, 'head_name': user.name});
    }
  }

  // Update department when user is updated
  Future<void> _updateDepartmentOnUserUpdate(
    UserModel oldUser,
    UserModel newUser,
  ) async {
    // Handle department change
    if (oldUser.departmentId != newUser.departmentId) {
      // Decrement old department count
      if (oldUser.departmentId != null) {
        await _decrementDepartmentCount(oldUser.departmentId!);
        // Clear head if was dept head
        if (oldUser.role == UserRole.departmentHead) {
          await _clearDepartmentHead(oldUser.departmentId!);
        }
      }

      // Increment new department count
      if (newUser.departmentId != null) {
        await _firestore
            .collection(FirebaseConstants.departmentsCollection)
            .doc(newUser.departmentId!)
            .update({'employee_count': FieldValue.increment(1)});

        // Set as head if dept head
        if (newUser.role == UserRole.departmentHead) {
          await _firestore
              .collection(FirebaseConstants.departmentsCollection)
              .doc(newUser.departmentId!)
              .update({'head_id': newUser.id, 'head_name': newUser.name});
        }
      }
    }
    // Handle role change in same department
    else if (oldUser.role != newUser.role && newUser.departmentId != null) {
      // Changed to dept head
      if (newUser.role == UserRole.departmentHead) {
        await _firestore
            .collection(FirebaseConstants.departmentsCollection)
            .doc(newUser.departmentId!)
            .update({'head_id': newUser.id, 'head_name': newUser.name});
      }
      // Changed from dept head
      else if (oldUser.role == UserRole.departmentHead) {
        await _clearDepartmentHead(newUser.departmentId!);
      }
    }
  }

  // Decrement department employee count
  Future<void> _decrementDepartmentCount(String departmentId) async {
    await _firestore
        .collection(FirebaseConstants.departmentsCollection)
        .doc(departmentId)
        .update({'employee_count': FieldValue.increment(-1)});
  }

  // Clear department head
  Future<void> _clearDepartmentHead(String departmentId) async {
    await _firestore
        .collection(FirebaseConstants.departmentsCollection)
        .doc(departmentId)
        .update({'head_id': null, 'head_name': null});
  }

  @override
  Future<UserModel?> getUserByEmployeeId(String employeeId) async {
    try {
      // Search across all role collections
      for (final collection in [
        FirebaseConstants.superAdminsCollection,
        FirebaseConstants.departmentHeadsCollection,
        FirebaseConstants.employeesCollection,
      ]) {
        final snapshot = await _firestore
            .collection(collection)
            .where('employee_id', isEqualTo: employeeId)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final doc = snapshot.docs.first;
          return UserModel.fromJson({...doc.data(), 'id': doc.id});
        }
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get user by employee ID: ${e.toString()}');
    }
  }
}
