import 'package:flutter/material.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/change_password_screen.dart';
import 'route_names.dart';

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    RouteNames.splash: (_) => const SplashScreen(),
    RouteNames.login: (_) => const LoginScreen(),
    RouteNames.home: (_) => const HomeScreen(),
    RouteNames.profile: (_) => const ProfileScreen(),
    RouteNames.changePassword: (_) => const ChangePasswordScreen(),
  };
}
