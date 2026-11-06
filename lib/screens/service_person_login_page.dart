import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'service_person_dashboard_page.dart';

class ServicePersonLoginPage extends StatefulWidget {
  const ServicePersonLoginPage({super.key});

  @override
  State<ServicePersonLoginPage> createState() => _ServicePersonLoginPageState();
}

class _ServicePersonLoginPageState extends State<ServicePersonLoginPage>
    with TickerProviderStateMixin {
  static const Color darkBg = Color(0xFF13241B);
  static const Color darkBg2 = Color(0xFF0D1A13);
  static const Color mintAccent = Color(0xFFB7F5C8);
  static const Color cardGlass = Color(0x1AFFFFFF);

  late AnimationController _controller;
  late AnimationController _floatController;

  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatController.dispose();
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (idController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const ServicePersonDashboardPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: _buildLoginCard(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [darkBg, darkBg2],
            ),
          ),
        ),

        Positioned(top: -120, right: -100, child: _glowOrb(300)),

        Positioned(bottom: -140, left: -120, child: _glowOrb(320)),

        AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            final value = math.sin(_floatController.value * math.pi);

            return Positioned(
              top: 100 + value * 12,
              right: 70,
              child: Icon(
                Icons.handyman_outlined,
                size: 46,
                color: mintAccent.withOpacity(0.07),
              ),
            );
          },
        ),

        Positioned(
          top: 210,
          left: 70,
          child: Icon(
            Icons.room_service_outlined,
            size: 38,
            color: mintAccent.withOpacity(0.05),
          ),
        ),

        Positioned(
          bottom: 170,
          right: 80,
          child: Icon(
            Icons.cleaning_services_outlined,
            size: 42,
            color: mintAccent.withOpacity(0.05),
          ),
        ),
      ],
    );
  }

  Widget _glowOrb(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: mintAccent.withOpacity(0.025),
        boxShadow: [
          BoxShadow(
            color: mintAccent.withOpacity(0.06),
            blurRadius: 100,
            spreadRadius: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: 440,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: cardGlass,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopIcon(),

          const SizedBox(height: 26),

          const Text(
            'Service Person Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Sign in to view and manage your assigned service requests.',
            style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.5),
          ),

          const SizedBox(height: 30),

          const Text(
            'Service Person ID',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 9),

          _buildTextField(
            controller: idController,
            hint: 'Enter your service ID',
            icon: Icons.badge_outlined,
          ),

          const SizedBox(height: 20),

          const Text(
            'Password',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 9),

          _buildTextField(
            controller: passwordController,
            hint: 'Enter your password',
            icon: Icons.lock_outline,
            obscureText: obscurePassword,
            suffix: IconButton(
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.white38,
                size: 19,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot password?',
                style: TextStyle(color: mintAccent, fontSize: 12),
              ),
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: mintAccent,
                foregroundColor: darkBg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: darkBg,
                      ),
                    )
                  : const Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 26),

          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '← Back to StayOps',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopIcon() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: mintAccent.withOpacity(0.10),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: mintAccent.withOpacity(0.18)),
      ),
      child: const Icon(
        Icons.room_service_outlined,
        color: mintAccent,
        size: 28,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.white38, size: 19),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withOpacity(0.035),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.07)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.07)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: mintAccent, width: 1.2),
        ),
      ),
    );
  }
}
