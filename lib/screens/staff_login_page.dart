import 'package:flutter/material.dart';
import 'staff_dashboard_page.dart';

class StaffLoginPage extends StatefulWidget {
  const StaffLoginPage({super.key});

  @override
  State<StaffLoginPage> createState() => _StaffLoginPageState();
}

class _StaffLoginPageState extends State<StaffLoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController staffIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  static const Color darkBg = Color(0xFF13241B);
  static const Color darkBg2 = Color(0xFF0D1A13);
  static const Color mintAccent = Color(0xFFB7F5C8);

  @override
  void dispose() {
    staffIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StaffDashboardPage()),
    );
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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: mintAccent.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(23),
                        border: Border.all(
                          color: mintAccent.withValues(alpha: 0.18),
                        ),
                      ),
                      child: const Icon(
                        Icons.room_service_rounded,
                        color: mintAccent,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Staff Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sign in to manage your assigned service requests.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.035),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Staff ID',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 9),
                            TextFormField(
                              controller: staffIdController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter your staff ID',
                                hintStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.30),
                                ),
                                prefixIcon: Icon(
                                  Icons.badge_outlined,
                                  color: Colors.white.withValues(alpha: 0.45),
                                ),
                                filled: true,
                                fillColor: Colors.white.withValues(
                                  alpha: 0.045,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.07),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: const BorderSide(
                                    color: mintAccent,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your staff ID';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 22),
                            Text(
                              'Password',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 9),
                            TextFormField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                hintStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.30),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline_rounded,
                                  color: Colors.white.withValues(alpha: 0.45),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white.withValues(alpha: 0.45),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white.withValues(
                                  alpha: 0.045,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.07),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: const BorderSide(
                                    color: mintAccent,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mintAccent,
                                  foregroundColor: darkBg,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'StayOps • Staff Portal',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.30),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
