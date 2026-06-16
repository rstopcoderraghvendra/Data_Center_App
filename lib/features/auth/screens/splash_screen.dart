/*
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
*/

import 'dart:async';
import 'dart:math' as math;

import 'package:data_care_app/core/storage/local_storage.dart';
import 'package:data_care_app/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

import '../../../app/routes/route_names.dart';
import '../../../core/network/api_client.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final _authRepository = AuthRepository(
    ApiClient(storage: LocalStorage()),
  );

  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.78,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
    _initAuth();
  }

  Future<void> _initAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final isLoggedIn = await _authRepository.isLoggedIn();

    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(
      isLoggedIn ? RouteNames.home : RouteNames.login,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _SplashPremiumBackground(),

          Positioned.fill(
            child: CustomPaint(
              painter: _SplashPatternPainter(),
            ),
          ),

          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildLogo(),

                          const SizedBox(height: 26),

                          const Text(
                            'Data Care',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.6,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Smart Customer Data Collection',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.78),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),

                          const SizedBox(height: 24),

                          _buildInfoCard(),

                          const SizedBox(height: 30),

                          _buildLoadingSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 24,
            right: 24,
            bottom: 26,
            child: SafeArea(
              top: false,
              child: Text(
                'Secure • Organized • Reliable',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.58),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animationController.value * math.pi * 2,
              child: Container(
                height: 132,
                width: 132,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.10),
                    width: 1.2,
                  ),
                ),
              ),
            );
          },
        ),

        Container(
          height: 112,
          width: 112,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF35E3FF),
                Color(0xFF3D7BFF),
                Color(0xFF7C4DFF),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF35E3FF).withOpacity(0.35),
                blurRadius: 34,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 18,
                child: Container(
                  height: 54,
                  width: 66,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.32),
                    ),
                  ),
                ),
              ),

              const Positioned(
                top: 31,
                child: Icon(
                  Icons.storage_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),

              Positioned(
                bottom: 18,
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.verified_user_rounded,
                    color: Color(0xFF3158F6),
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.11),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.16),
        ),
      ),
      child: Column(
        children: [
          _purposeRow(
            icon: Icons.person_search_rounded,
            title: 'Customer Data Collection',
          ),
          const SizedBox(height: 10),
          _purposeRow(
            icon: Icons.receipt_long_rounded,
            title: 'Bill Distribution Management',
          ),
          const SizedBox(height: 10),
          _purposeRow(
            icon: Icons.security_rounded,
            title: 'Safe & Verified Records',
          ),
        ],
      ),
    );
  }

  Widget _purposeRow({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.16),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              fontSize: 12.8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        SizedBox(
          height: 26,
          width: 26,
          child: CircularProgressIndicator(
            strokeWidth: 2.6,
            valueColor: AlwaysStoppedAnimation(
              Colors.white.withOpacity(0.95),
            ),
            backgroundColor: Colors.white.withOpacity(0.14),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Preparing your secure workspace...',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.68),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SplashPremiumBackground extends StatelessWidget {
  const _SplashPremiumBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF07112F),
                Color(0xFF101C55),
                Color(0xFF182E82),
                Color(0xFF0B1028),
              ],
            ),
          ),
        ),

        Positioned(
          top: -90,
          right: -80,
          child: _GlowCircle(
            size: 250,
            color: Color(0xFF35E3FF),
            opacity: 0.24,
          ),
        ),

        Positioned(
          bottom: -120,
          left: -80,
          child: _GlowCircle(
            size: 280,
            color: Color(0xFF7C4DFF),
            opacity: 0.25,
          ),
        ),

        Positioned(
          top: 220,
          left: -60,
          child: _GlowCircle(
            size: 150,
            color: Color(0xFF00C2FF),
            opacity: 0.14,
          ),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _GlowCircle({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(opacity),
            color.withOpacity(0.04),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _SplashPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.035)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;

    const gap = 38.0;

    for (double x = -size.height; x < size.width; x += gap) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        linePaint,
      );
    }

    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.055)
      ..style = PaintingStyle.fill;

    for (double x = 24; x < size.width; x += 48) {
      for (double y = 24; y < size.height; y += 48) {
        canvas.drawCircle(
          Offset(x, y),
          1.3,
          dotPaint,
        );
      }
    }

    final arcPaint = Paint()
      ..color = const Color(0xFF35E3FF).withOpacity(0.12)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2 - 50),
        radius: 150,
      ),
      -math.pi * 0.9,
      math.pi * 1.25,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
