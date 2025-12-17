import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/data/models/user_model.dart';

/// Utility to sync department statistics with actual user counts
class DepartmentSyncUtil {
  static Future<void> syncAllDepartments() async {
    final firestore = FirebaseFirestore.instance;

    print('🔄 Starting department sync...');

    // Get all departments
    final depts = await firestore.collection('departments').get();

    for (final deptDoc in depts.docs) {
      final deptId = deptDoc.id;
      print('📊 Syncing department: ${deptDoc.data()['name']}');

      // Get all active users in this department
      final users = await firestore
          .collection('users')
          .where('departmentId', isEqualTo: deptId)
          .where('isActive', isEqualTo: true)
          .get();

      // Count employees
      final employeeCount = users.docs.length;

      // Find department head
      String? headId;
      String? headName;

      for (final userDoc in users.docs) {
        final userData = userDoc.data();
        if (userData['role'] == 'department_head') {
          headId = userDoc.id;
          headName = userData['name'];
          break; // Only one head per department
        }
      }

      // Update department
      await deptDoc.reference.update({
        'employeeCount': employeeCount,
        'headId': headId,
        'headName': headName,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print(
        '  ✅ Updated: $employeeCount employees, head: ${headName ?? "none"}',
      );
    }

    print('✅ Department sync complete!');
  }
}
