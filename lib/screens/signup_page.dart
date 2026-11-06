import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dashboard_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final AnimationController _floatController;

  final _nameController = TextEditingController();
  final _hotelNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
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
    _nameController.dispose();
    _hotelNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, anim, __) => const DashboardPage(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    });
  }

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
            // Decorative background layer
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

            // Foreground: the signup card
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: _slide,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 460),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: mintAccent.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.apartment_rounded,
                                    color: mintAccent,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                const Text(
                                  'Create Your Hotel Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Set up StayOps for your property. You can invite your team later.',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 28),

                                _label('Your Full Name'),
                                _buildTextField(
                                  controller: _nameController,
                                  hint: 'e.g. Arsh Kumar',
                                  icon: Icons.person_outline_rounded,
                                ),
                                const SizedBox(height: 18),

                                _label('Hotel Name'),
                                _buildTextField(
                                  controller: _hotelNameController,
                                  hint: 'e.g. Grand Palace Hotel',
                                  icon: Icons.apartment_rounded,
                                ),
                                const SizedBox(height: 18),

                                _label('Email Address'),
                                _buildTextField(
                                  controller: _emailController,
                                  hint: 'you@hotel.com',
                                  icon: Icons.mail_outline_rounded,
                                ),
                                const SizedBox(height: 18),

                                _label('Password'),
                                _buildTextField(
                                  controller: _passwordController,
                                  hint: 'Create a password',
                                  icon: Icons.lock_outline_rounded,
                                  obscure: _obscurePassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.white38,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                _label('Confirm Password'),
                                _buildTextField(
                                  controller: _confirmPasswordController,
                                  hint: 'Re-enter your password',
                                  icon: Icons.lock_outline_rounded,
                                  obscure: _obscureConfirm,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirm
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.white38,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscureConfirm = !_obscureConfirm,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 28),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : _handleSignUp,
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
                                            'CREATE ACCOUNT',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 13,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Already have an account? ',
                                        ),
                                        TextSpan(
                                          text: 'Sign In',
                                          style: const TextStyle(
                                            color: mintAccent,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () =>
                                                Navigator.of(context).pop(),
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
            ),
          ],
        ),
      ),
    );
  }

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

  List<Widget> _floatingIcons(double t) {
    final icons = [
      (Icons.bed_rounded, const Alignment(-0.75, -0.4), 0.0),
      (Icons.key_rounded, const Alignment(0.75, -0.5), 1.5),
      (Icons.hotel_rounded, const Alignment(-0.7, 0.65), 3.0),
      (Icons.local_florist_rounded, const Alignment(0.75, 0.6), 4.2),
      (Icons.wifi_rounded, const Alignment(0.1, -0.85), 2.1),
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

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white, fontSize: 14),
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
      ),
    );
  }
}

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
