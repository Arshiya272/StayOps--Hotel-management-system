import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'guest_dashboard_page.dart';
import 'guest_signup_page.dart';

class GuestLoginPage extends StatefulWidget {
  const GuestLoginPage({super.key});

  @override
  State<GuestLoginPage> createState() => _GuestLoginPageState();
}

class _GuestLoginPageState extends State<GuestLoginPage>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final AnimationController _floatController;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  static const darkBg = Color(0xFF13241B);
  static const darkBg2 = Color(0xFF0D1A13);
  static const mintAccent = Color(0xFFB7F5C8);
  static const cardGlass = Color(0x1AFFFFFF);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  // ============================================================
  // SIGN IN
  // ============================================================

  void _handleSignIn() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Demo login:
    // Any non-empty email + any non-empty password is accepted.
    if (email.isEmpty || password.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, anim, __) => const GuestDashboardPage(),
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(opacity: anim, child: child);
          },
        ),
      );
    });
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Password is required';
    }

    return null;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [darkBg, darkBg2],
          ),
        ),
        child: Stack(
          children: [
            // ==================================================
            // BACKGROUND ANIMATION
            // ==================================================
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, _) {
                  final t = _floatController.value;

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: const Alignment(-0.6, -0.7),
                              radius: 1.3,
                              colors: [
                                mintAccent.withOpacity(0.16),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: const Alignment(0.8, 0.8),
                              radius: 1.1,
                              colors: [
                                const Color(0xFFFFD98A).withOpacity(0.14),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -120 + (math.sin(t * math.pi * 2) * 30),
                        left: -100 + (math.cos(t * math.pi * 2) * 20),
                        child: _glowOrb(420, mintAccent.withOpacity(0.22)),
                      ),
                      Positioned(
                        bottom: -140 + (math.cos(t * math.pi * 2) * 30),
                        right: -120 + (math.sin(t * math.pi * 2) * 20),
                        child: _glowOrb(
                          480,
                          const Color(0xFFFFD98A).withOpacity(0.18),
                        ),
                      ),
                      Positioned(
                        top: 200 + (math.sin(t * math.pi * 2 + 2) * 40),
                        right: 100 + (math.cos(t * math.pi * 2) * 30),
                        child: _glowOrb(200, mintAccent.withOpacity(0.20)),
                      ),
                      Positioned.fill(
                        child: CustomPaint(painter: _DotGridPainter()),
                      ),
                      ..._floatingIcons(t),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: -200,
                        right: -200,
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: 0.05 + (0.03 * math.sin(t * math.pi * 2)),
                            child: Transform.rotate(
                              angle: -0.4,
                              child: const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.white,
                                      Colors.transparent,
                                    ],
                                    stops: [0.3, 0.5, 0.7],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // ==================================================
            // LOGIN CARD
            // ==================================================
            Center(
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Container(
                        padding: const EdgeInsets.all(36),
                        decoration: BoxDecoration(
                          color: cardGlass,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // --------------------------
                              // ICON
                              // --------------------------
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: mintAccent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: mintAccent,
                                  size: 28,
                                ),
                              ),

                              const SizedBox(height: 24),

                              // --------------------------
                              // TITLE
                              // --------------------------
                              const Text(
                                'Welcome Back 👋',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                'Sign in to continue to your stay',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 32),

                              // --------------------------
                              // EMAIL
                              // --------------------------
                              const Text(
                                'Email Address',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              _buildTextField(
                                controller: _emailController,
                                hint: 'Enter your email',
                                icon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateEmail,
                              ),

                              const SizedBox(height: 20),

                              // --------------------------
                              // PASSWORD
                              // --------------------------
                              const Text(
                                'Password',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              _buildTextField(
                                controller: _passwordController,
                                hint: 'Enter your password',
                                icon: Icons.lock_outline_rounded,
                                obscure: _obscurePassword,
                                validator: _validatePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.white38,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 10),

                              // --------------------------
                              // FORGOT PASSWORD
                              // --------------------------
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: mintAccent,
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // --------------------------
                              // SIGN IN BUTTON
                              // --------------------------
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleSignIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: mintAccent,
                                    foregroundColor: darkBg2,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.4,
                                            color: darkBg2,
                                          ),
                                        )
                                      : const Text(
                                          'SIGN IN',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // --------------------------
                              // SIGNUP LINK
                              // --------------------------
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 13,
                                    ),
                                    children: [
                                      const TextSpan(text: 'New guest? '),
                                      TextSpan(
                                        text: 'Create an account',
                                        style: const TextStyle(
                                          color: mintAccent,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.of(
                                              context,
                                            ).pushReplacement(
                                              PageRouteBuilder(
                                                transitionDuration:
                                                    const Duration(
                                                      milliseconds: 400,
                                                    ),
                                                pageBuilder: (_, anim, __) =>
                                                    const GuestSignupPage(),
                                                transitionsBuilder:
                                                    (_, anim, __, child) {
                                                      return FadeTransition(
                                                        opacity: anim,
                                                        child: child,
                                                      );
                                                    },
                                              ),
                                            );
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // GLOW ORB
  // ============================================================

  Widget _glowOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
      ),
    );
  }

  // ============================================================
  // FLOATING ICONS
  // ============================================================

  List<Widget> _floatingIcons(double t) {
    final icons = [
      (Icons.bed_rounded, const Alignment(-0.75, -0.35), 0.0),
      (Icons.key_rounded, const Alignment(0.7, -0.55), 1.5),
      (Icons.hotel_rounded, const Alignment(-0.65, 0.6), 3.0),
      (Icons.local_florist_rounded, const Alignment(0.8, 0.4), 4.2),
      (Icons.wifi_rounded, const Alignment(0.15, -0.8), 2.1),
    ];

    return icons.map((entry) {
      final (icon, align, phase) = entry;

      final bob = math.sin((t * math.pi * 2) + phase) * 10;

      return Align(
        alignment: align,
        child: Transform.translate(
          offset: Offset(0, bob),
          child: Icon(icon, size: 28, color: Colors.white.withOpacity(0.06)),
        ),
      );
    }).toList();
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      cursorColor: mintAccent,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white38, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        errorStyle: const TextStyle(color: Color(0xFFFF8A8A), fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: mintAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
        ),
      ),
    );
  }
}

// ================================================================
// DOT GRID BACKGROUND
// ================================================================

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.035)
      ..style = PaintingStyle.fill;

    const spacing = 28.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
