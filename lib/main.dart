import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:silver_sves/features/auth/presentation/screens/phone_login_screen.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/seed_data_screen.dart'; // Added for testing
import 'core/services/user_activity_tracker.dart';
import 'core/utils/fix_employee_ids_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _activityTracker = UserActivityTracker();

  @override
  void initState() {
    super.initState();
    // Add lifecycle observer
    WidgetsBinding.instance.addObserver(this);
    // Update on app start
    _updateLastUsed();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Update lastUsed when app comes to foreground
    if (state == AppLifecycleState.resumed) {
      _updateLastUsed();
    }
  }

  void _updateLastUsed() {
    // Run in background to not block UI
    _activityTracker.updateLastUsed();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 11 Pro size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Leave Management',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const PhoneLoginScreen(),
        );
      },
    );
  }
}
