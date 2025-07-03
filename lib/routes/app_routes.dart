import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/user_home_screen/user_home_screen.dart';
import '../presentation/worker_dashboard/worker_dashboard.dart';
import '../presentation/role_selection/role_selection.dart';
import '../presentation/worker_listing_screen/worker_listing_screen.dart';
import '../presentation/worker_profile_form/worker_profile_form.dart';
import '../presentation/auth/phone_auth_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String phoneAuth = '/phone-auth';
  static const String userHomeScreen = '/user-home-screen';
  static const String workerDashboard = '/worker-dashboard';
  static const String roleSelection = '/role-selection';
  static const String workerListingScreen = '/worker-listing-screen';
  static const String workerProfileForm = '/worker-profile-form';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    phoneAuth: (context) => const PhoneAuthScreen(),
    userHomeScreen: (context) => const UserHomeScreen(),
    workerDashboard: (context) => const WorkerDashboard(),
    roleSelection: (context) => const RoleSelection(),
    workerListingScreen: (context) => const WorkerListingScreen(),
    workerProfileForm: (context) => const WorkerProfileForm(),
    // TODO: Add your other routes here
  };
}
