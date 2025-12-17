import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../domain/repositories/department_repository.dart';
import '../models/department_model.dart';

/// Firebase implementation of DepartmentRepository
class FirebaseDepartmentRepository implements DepartmentRepository {
  final FirebaseFirestore _firestore;

  FirebaseDepartmentRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<DepartmentModel> createDepartment(DepartmentModel department) async {
    try {
      final departmentData = department
          .copyWith(createdAt: DateTime.now(), updatedAt: DateTime.now())
          .toJson();

      final docRef = await _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .add(departmentData);

      final createdDept = department.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Update with the generated ID
      await docRef.update({'id': docRef.id});

      return createdDept;
    } catch (e) {
      throw Exception('Failed to create department: ${e.toString()}');
    }
  }

  @override
  Stream<List<DepartmentModel>> getDepartments({bool activeOnly = false}) {
    try {
      Query query = _firestore.collection(
        FirebaseConstants.departmentsCollection,
      );

      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }

      return query.snapshots().map((snapshot) {
        final departments = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return DepartmentModel.fromJson({...data, 'id': doc.id});
        }).toList();

        // Sort by name in memory to avoid composite index
        departments.sort((a, b) => a.name.compareTo(b.name));

        return departments;
      });
    } catch (e) {
      throw Exception('Failed to get departments: ${e.toString()}');
    }
  }

  @override
  Future<DepartmentModel?> getDepartmentById(String id) async {
    try {
      final doc = await _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .doc(id)
          .get();

      if (!doc.exists) return null;

      final data = doc.data()!;
      return DepartmentModel.fromJson({...data, 'id': doc.id});
    } catch (e) {
      throw Exception('Failed to get department: ${e.toString()}');
    }
  }

  @override
  Future<void> updateDepartment(DepartmentModel department) async {
    try {
      final departmentData = department
          .copyWith(updatedAt: DateTime.now())
          .toJson();

      await _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .doc(department.id)
          .update(departmentData);
    } catch (e) {
      throw Exception('Failed to update department: ${e.toString()}');
    }
  }

  @override
  Future<void> assignDepartmentHead(
    String deptId,
    String userId,
    String userName,
  ) async {
    try {
      await _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .doc(deptId)
          .update({
            'headId': userId,
            'headName': userName,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Failed to assign department head: ${e.toString()}');
    }
  }

  @override
  Future<void> removeDepartmentHead(String deptId) async {
    try {
      await _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .doc(deptId)
          .update({
            'headId': null,
            'headName': null,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Failed to remove department head: ${e.toString()}');
    }
  }

  @override
  Future<String> generateEmployeeId(String deptId) async {
    try {
      final deptRef = _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .doc(deptId);

      // Get current department data
      final deptDoc = await deptRef.get();
      if (!deptDoc.exists) {
        throw Exception('Department not found');
      }

      final dept = DepartmentModel.fromJson({
        ...deptDoc.data()!,
        'id': deptDoc.id,
      });

      // Generate employee ID
      final employeeId = dept.getNextEmployeeId();

      // Increment counter atomically
      await deptRef.update({'employeeIdCounter': FieldValue.increment(1)});

      return employeeId;
    } catch (e) {
      throw Exception('Failed to generate employee ID: ${e.toString()}');
    }
  }

  @override
  Future<void> updateEmployeeCount(String deptId, int delta) async {
    try {
      await _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .doc(deptId)
          .update({'employeeCount': FieldValue.increment(delta)});
    } catch (e) {
      throw Exception('Failed to update employee count: ${e.toString()}');
    }
  }

  @override
  Future<void> deactivateDepartment(String id) async {
    try {
      await _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .doc(id)
          .update({
            'isActive': false,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Failed to deactivate department: ${e.toString()}');
    }
  }

  @override
  Future<void> activateDepartment(String id) async {
    try {
      await _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .doc(id)
          .update({
            'isActive': true,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Failed to activate department: ${e.toString()}');
    }
  }

  @override
  Future<bool> isDepartmentCodeUnique(String code, {String? excludeId}) async {
    try {
      final query = await _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .where('code', isEqualTo: code.toUpperCase())
          .get();

      if (query.docs.isEmpty) return true;

      // If excluding an ID (for updates), check if any other dept has this code
      if (excludeId != null) {
        return query.docs.every((doc) => doc.id == excludeId);
      }

      return false;
    } catch (e) {
      throw Exception('Failed to check department code: ${e.toString()}');
    }
  }

  @override
  Future<int> getDepartmentCount({bool activeOnly = true}) async {
    try {
      Query query = _firestore.collection(
        FirebaseConstants.departmentsCollection,
      );

      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }

      final snapshot = await query.count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('Failed to get department count: ${e.toString()}');
    }
  }
}
