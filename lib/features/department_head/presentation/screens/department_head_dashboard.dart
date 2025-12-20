import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'dept_head_home_tab.dart';
import 'dept_head_team_tab.dart';
import 'dept_head_profile_tab.dart';

/// Department Head Dashboard with bottom navigation
class DepartmentHeadDashboard extends StatefulWidget {
  const DepartmentHeadDashboard({super.key});

  @override
  State<DepartmentHeadDashboard> createState() =>
      _DepartmentHeadDashboardState();
}

class _DepartmentHeadDashboardState extends State<DepartmentHeadDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = const [
    DeptHeadHomeTab(),
    DeptHeadTeamTab(),
    DeptHeadProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'My Team'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
