import 'package:flutter/material.dart';

import 'hotel_registration_page.dart';
import 'login_page.dart';
import 'staff_login_page.dart';

class HotelRolePage extends StatelessWidget {
  const HotelRolePage({super.key});

  static const Color darkBg = Color(0xFF13241B);
  static const Color darkBg2 = Color(0xFF0D1A13);
  static const Color mintAccent = Color(0xFFB7F5C8);

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
                constraints: const BoxConstraints(maxWidth: 850),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // ICON
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: mintAccent.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: mintAccent.withValues(alpha: 0.18),
                        ),
                      ),
                      child: const Icon(
                        Icons.apartment_rounded,
                        color: mintAccent,
                        size: 34,
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'Welcome to StayOps',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Choose how you want to access your hotel.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 50),

                    // LOGIN OPTIONS
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth >= 650) {
                          return Row(
                            children: [
                              Expanded(
                                child: _roleCard(
                                  context,
                                  icon: Icons.admin_panel_settings_rounded,
                                  title: 'Login as Admin',
                                  description:
                                      'Manage your hotel, rooms, bookings and daily operations.',
                                  buttonText: 'Continue as Admin',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LoginPage(),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 24),

                              Expanded(
                                child: _roleCard(
                                  context,
                                  icon: Icons.room_service_rounded,
                                  title: 'Login as Staff',
                                  description:
                                      'Handle assigned requests, track tasks and manage guest services.',
                                  buttonText: 'Continue as Staff',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const StaffLoginPage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }

                        return Column(
                          children: [
                            _roleCard(
                              context,
                              icon: Icons.admin_panel_settings_rounded,
                              title: 'Login as Admin',
                              description:
                                  'Manage your hotel, rooms, bookings and daily operations.',
                              buttonText: 'Continue as Admin',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPage(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            _roleCard(
                              context,
                              icon: Icons.room_service_rounded,
                              title: 'Login as Staff',
                              description:
                                  'Handle assigned requests, track tasks and manage guest services.',
                              buttonText: 'Continue as Staff',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const StaffLoginPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 35),

                    // REGISTER HOTEL
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: mintAccent.withValues(alpha: 0.035),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: mintAccent.withValues(alpha: 0.10),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.add_business_rounded,
                            color: mintAccent,
                            size: 28,
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            'New to StayOps?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 7),

                          Text(
                            'Register your hotel and get access after verification.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.50),
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 18),

                          SizedBox(
                            height: 45,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const HotelRegistrationPage(),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: mintAccent,
                                side: BorderSide(
                                  color: mintAccent.withValues(alpha: 0.55),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Register Hotel',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 45),

                    Text(
                      'Hotel management made simpler.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
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

  Widget _roleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: mintAccent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: mintAccent, size: 30),
          ),

          const SizedBox(height: 22),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 13,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: mintAccent,
                foregroundColor: darkBg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
