import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_constants.dart';
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
      final userData = user
          .copyWith(createdAt: DateTime.now(), updatedAt: DateTime.now())
          .toJson();

      final docRef = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .add(userData);

      final createdUser = user.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Update with the generated ID
      await docRef.update({'id': docRef.id});

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
      Query query = _firestore.collection(FirebaseConstants.usersCollection);

      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }

      if (role != null) {
        query = query.where('role', isEqualTo: _getRoleString(role));
      }

      if (departmentId != null) {
        query = query.where('departmentId', isEqualTo: departmentId);
      }

      return query.snapshots().map((snapshot) {
        final users = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return UserModel.fromJson({...data, 'id': doc.id});
        }).toList();

        // Sort by name in memory to avoid composite index
        users.sort((a, b) => a.name.compareTo(b.name));

        return users;
      });
    } catch (e) {
      throw Exception('Failed to get users: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    try {
      final doc = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(id)
          .get();

      if (!doc.exists) return null;

      final data = doc.data()!;
      return UserModel.fromJson({...data, 'id': doc.id});
    } catch (e) {
      throw Exception('Failed to get user: ${e.toString()}');
    }
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      // Search by name (case-insensitive)
      final nameQuery = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();

      // Search by employee ID
      final empIdQuery = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .where('employeeId', isGreaterThanOrEqualTo: query.toUpperCase())
          .where('employeeId', isLessThan: query.toUpperCase() + 'Z')
          .get();

      // Search by phone
      final phoneQuery = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .where('phone', isGreaterThanOrEqualTo: query)
          .where('phone', isLessThan: query + 'z')
          .get();

      // Combine results and remove duplicates
      final Set<String> seenIds = {};
      final List<UserModel> users = [];

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

      return users;
    } catch (e) {
      throw Exception('Failed to search users: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      // Get old user data to compare changes
      final oldUserDoc = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.id)
          .get();

      if (oldUserDoc.exists) {
        final oldUser = UserModel.fromJson({
          ...oldUserDoc.data()!,
          'id': oldUserDoc.id,
        });

        // Update department statistics if needed
        await _updateDepartmentOnUserUpdate(oldUser, user);
      }

      final userData = user.copyWith(updatedAt: DateTime.now()).toJson();

      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.id)
          .update(userData);
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
  }

  @override
  Future<void> deactivateUser(String userId) async {
    try {
      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .update({
            'isActive': false,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Failed to deactivate user: ${e.toString()}');
    }
  }

  @override
  Future<void> activateUser(String userId) async {
    try {
      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .update({
            'isActive': true,
            'updatedAt': FieldValue.serverTimestamp(),
          });
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

      // If excluding an ID (for updates), check if any other user has this phone
      if (excludeId != null) {
        return query.docs.every((doc) => doc.id == excludeId);
      }

      return false;
    } catch (e) {
      throw Exception('Failed to check phone uniqueness: ${e.toString()}');
    }
  }

  @override
  Future<int> getUserCount({bool activeOnly = true}) async {
    try {
      Query query = _firestore.collection(FirebaseConstants.usersCollection);

      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }

      final snapshot = await query.count().get();
      return snapshot.count ?? 0;
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

      for (final role in UserRole.values) {
        Query query = _firestore
            .collection(FirebaseConstants.usersCollection)
            .where('role', isEqualTo: _getRoleString(role));

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
      Query query = _firestore
          .collection(FirebaseConstants.usersCollection)
          .where('departmentId', isEqualTo: departmentId);

      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson({...data, 'id': doc.id});
      }).toList();
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

  // Update department when user is created
  Future<void> _updateDepartmentOnUserCreate(
    String departmentId,
    UserModel user,
  ) async {
    final deptRef = _firestore
        .collection(FirebaseConstants.departmentsCollection)
        .doc(departmentId);

    // Increment employee count
    await deptRef.update({'employeeCount': FieldValue.increment(1)});

    // If user is department head, set head info
    if (user.role == UserRole.departmentHead) {
      await deptRef.update({'headId': user.id, 'headName': user.name});
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
            .update({'employeeCount': FieldValue.increment(1)});

        // Set as head if dept head
        if (newUser.role == UserRole.departmentHead) {
          await _firestore
              .collection(FirebaseConstants.departmentsCollection)
              .doc(newUser.departmentId!)
              .update({'headId': newUser.id, 'headName': newUser.name});
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
            .update({'headId': newUser.id, 'headName': newUser.name});
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
        .update({'employeeCount': FieldValue.increment(-1)});
  }

  // Clear department head
  Future<void> _clearDepartmentHead(String departmentId) async {
    await _firestore
        .collection(FirebaseConstants.departmentsCollection)
        .doc(departmentId)
        .update({'headId': null, 'headName': null});
  }
}
