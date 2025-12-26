import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/utils/id_generator_util.dart';
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
      // Use Firebase auto-generated ID
      final docRef = _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .doc();
      final departmentId = docRef.id;

      // Generate shortened unique ID from Firebase ID with 'dept_' prefix
      final uniqueId = IdGeneratorUtil.generateDepartmentId(departmentId);

      final now = DateTime.now();

      // Create department with Firebase UUID and shortened unique ID
      final departmentData = department
          .copyWith(
            id: departmentId,
            uniqueId: uniqueId,
            createdAt: now,
            updatedAt: now,
          )
          .toJson();

      // Create document with auto-generated ID
      await docRef.set(departmentData);

      return department.copyWith(
        id: departmentId,
        uniqueId: uniqueId,
        createdAt: now,
        updatedAt: now,
      );
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
            'head_id': userId,
            'head_name': userName,
            'updated_at': FieldValue.serverTimestamp(),
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
            'head_id': null,
            'head_name': null,
            'updated_at': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Failed to remove department head: ${e.toString()}');
    }
  }

  @override
  Future<void> updateEmployeeCount(String deptId, int delta) async {
    try {
      await _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .doc(deptId)
          .update({'employee_count': FieldValue.increment(delta)});
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

  @override
  Future<DepartmentModel?> getDepartmentByUniqueId(String uniqueId) async {
    try {
      final snapshot = await _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .where('unique_id', isEqualTo: uniqueId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      return DepartmentModel.fromJson({...doc.data(), 'id': doc.id});
    } catch (e) {
      throw Exception('Failed to get department by unique ID: ${e.toString()}');
    }
  }
}
