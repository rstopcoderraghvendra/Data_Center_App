import 'dart:async';
import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:data_care_app/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import '../../../app/routes/route_names.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_client.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authRepository = AuthRepository(ApiClient(storage: LocalStorage()));
  @override
  void initState() {
    super.initState();
    // Timer(const Duration(seconds: 1), () {
    //   if (!mounted) {
    //     return;
    //   }
    //   Navigator.of(context).pushReplacementNamed(RouteNames.login);
    // });

    _initAuth();
  }

  Future<void> _initAuth() async {
    // Add a small delay for splash screen
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final isLoggedIn = await _authRepository.isLoggedIn();

    if (isLoggedIn) {
      // User is logged in, navigate to home
      Navigator.of(context).pushReplacementNamed(RouteNames.home);
    } else {
      // User is not logged in, navigate to login
      Navigator.of(context).pushReplacementNamed(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3F51B5),
              Color(0xFF5C6BC0),
              Color(0xFF7986CB),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 72,
                width: 72,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 36,
                  color: Color(0xFF3F51B5),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
