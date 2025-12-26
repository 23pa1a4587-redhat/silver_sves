import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../providers/dept_stats_provider.dart';
import 'dept_employees_tab.dart';
import 'dept_home_tab.dart';
import 'dept_leaves_tab.dart';
import 'dept_my_leaves_tab.dart';

/// Department Head Dashboard with bottom navigation (5 tabs)
class DeptHeadDashboard extends ConsumerStatefulWidget {
  const DeptHeadDashboard({super.key});

  @override
  ConsumerState<DeptHeadDashboard> createState() => _DeptHeadDashboardState();
}

class _DeptHeadDashboardState extends ConsumerState<DeptHeadDashboard> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    DeptHomeTab(),
    DeptEmployeesTab(),
    DeptLeavesTab(),
    DeptMyLeavesTab(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 10.r,
              offset: Offset(0, -2.h),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            // Refresh stats when navigating to Home tab
            if (index == 0) {
              ref.invalidate(deptHeadStatsProvider);
            }
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11.sp,
          ),
          unselectedLabelStyle: TextStyle(fontSize: 11.sp),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'My Team'),
            BottomNavigationBarItem(
              icon: Icon(Icons.approval),
              label: 'Requests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note),
              label: 'My Leaves',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
