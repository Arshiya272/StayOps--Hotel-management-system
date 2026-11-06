import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'guest_login_page.dart';
import 'login_page.dart';
import 'staff_login_page.dart';
import 'hotel_registration_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final AnimationController _floatController;

  final ScrollController _scrollController = ScrollController();

  bool _showFeaturesMenu = false;
  bool _showHotelOptions = false;
  int? _expandedFeatureIndex;

  static const Color darkBg = Color(0xFF13241B);
  static const Color darkBg2 = Color(0xFF0D1A13);
  static const Color mintAccent = Color(0xFFB7F5C8);
  static const Color cardGlass = Color(0x1AFFFFFF);

  static const Color buildingLight = Color(0xFFE8E3D8);
  static const Color buildingMid = Color(0xFFCFC8B5);
  static const Color windowGlow = Color(0xFFFFD98A);

  final List<(IconData, String, String)> hotelFeatures = const [
    (
      Icons.apartment_rounded,
      'Manage Property',
      'Set up and manage your hotel',
    ),
    (
      Icons.bed_rounded,
      'Manage Rooms',
      'Organize rooms, pricing and facilities',
    ),
    (
      Icons.calendar_month_rounded,
      'Handle Bookings',
      'Manage reservations with ease',
    ),
  ];

  final List<(IconData, String, String)> guestFeatures = const [
    (
      Icons.search_rounded,
      'Discover Stays',
      'Find the right room for your trip',
    ),
    (
      Icons.book_online_rounded,
      'Book a Room',
      'Reserve your stay in a few steps',
    ),
    (
      Icons.room_service_rounded,
      'Manage Your Stay',
      'Keep your stay details in one place',
    ),
  ];

  final List<(IconData, String, String)> allFeatures = const [
    (
      Icons.apartment_rounded,
      'For Hotels',
      'Manage your property, rooms and bookings',
    ),
    (
      Icons.luggage_rounded,
      'For Guests',
      'Discover, book and manage your stay',
    ),
    (
      Icons.calendar_month_rounded,
      'Smart Bookings',
      'Connect guests with available rooms',
    ),
    (
      Icons.room_service_rounded,
      'Stay Experience',
      'Keep everything about the stay together',
    ),
    (
      Icons.receipt_long_rounded,
      'Simple Checkout',
      'Make the end of every stay easier',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 1000;

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
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 900),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildNavBar(context, isWide),

                        const SizedBox(height: 40),

                        isWide
                            ? IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: _buildHeroText(context),
                                    ),
                                    const SizedBox(width: 32),
                                    Expanded(flex: 6, child: _build3DHotel()),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  _buildHeroText(context, center: true),
                                  const SizedBox(height: 32),
                                  _build3DHotel(height: 350),
                                ],
                              ),

                        const SizedBox(height: 56),

                        _buildAudienceSection(isWide),

                        const SizedBox(height: 28),

                        _buildFeatureStrip(isWide),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              if (_showFeaturesMenu)
                Positioned(
                  top: 80,
                  right: isWide ? 140 : 24,
                  child: _buildFeaturesDropdown(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NAVBAR
  // ---------------------------------------------------------------------------

  Widget _buildNavBar(BuildContext context, bool isWide) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: mintAccent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.apartment_rounded,
            color: mintAccent,
            size: 22,
          ),
        ),

        const SizedBox(width: 12),

        const Text(
          'StayOps',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        const Spacer(),

        if (isWide) ...[
          _navLink(
            'Home',
            active: true,
            onTap: () {
              setState(() {
                _showFeaturesMenu = false;
                _expandedFeatureIndex = null;
              });

              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
              );
            },
          ),

          _navLink(
            'Features',
            trailingIcon: _showFeaturesMenu
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            onTap: () {
              setState(() {
                _showFeaturesMenu = !_showFeaturesMenu;
                _expandedFeatureIndex = null;
              });
            },
          ),

          const SizedBox(width: 24),
        ],

        OutlinedButton(
          onPressed: () => _goToLogin(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white24),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Sign In'),
              SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _navLink(
    String label, {
    bool active = false,
    VoidCallback? onTap,
    IconData? trailingIcon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: active ? Colors.white : Colors.white60,
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),

                if (trailingIcon != null) ...[
                  const SizedBox(width: 2),
                  Icon(trailingIcon, size: 16, color: Colors.white60),
                ],
              ],
            ),

            if (active) ...[
              const SizedBox(height: 4),
              Container(width: 20, height: 2, color: mintAccent),
            ],
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FEATURES MENU
  // ---------------------------------------------------------------------------

  Widget _buildFeaturesDropdown() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * -10),
            child: child,
          ),
        );
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: darkBg2,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: _expandedFeatureIndex == null
              ? _buildFeatureMenuList()
              : _buildFeatureMenuDetail(_expandedFeatureIndex!),
        ),
      ),
    );
  }

  Widget _buildFeatureMenuList() {
    return Column(
      key: const ValueKey('list'),
      mainAxisSize: MainAxisSize.min,
      children: List.generate(allFeatures.length, (index) {
        final item = allFeatures[index];

        return InkWell(
          onTap: () {
            setState(() {
              _expandedFeatureIndex = index;
            });
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white10,
                  child: Icon(item.$1, color: mintAccent, size: 16),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        item.$3,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white24,
                  size: 12,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFeatureMenuDetail(int index) {
    final item = allFeatures[index];

    final detailMap = <String, List<String>>{
      'For Hotels': [
        'Set up your property',
        'Manage rooms and pricing',
        'Handle reservations',
      ],
      'For Guests': [
        'Discover available stays',
        'Book a room',
        'Manage your stay',
      ],
      'Smart Bookings': [
        'See room availability',
        'Create reservations',
        'Keep booking details together',
      ],
      'Stay Experience': [
        'Access stay information',
        'Request hotel services',
        'Keep everything organized',
      ],
      'Simple Checkout': [
        'View your final bill',
        'Track payment details',
        'Make checkout easier',
      ],
    };

    final points = detailMap[item.$2] ?? [];

    return Column(
      key: const ValueKey('detail'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _expandedFeatureIndex = null;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white70,
                  size: 18,
                ),
              ),
            ),

            const SizedBox(width: 8),

            CircleAvatar(
              radius: 14,
              backgroundColor: mintAccent.withValues(alpha: 0.15),
              child: Icon(item.$1, color: mintAccent, size: 14),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                item.$2,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Text(
          item.$3,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 14),

        ...points.map(
          (point) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: mintAccent,
                  size: 14,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _showFeaturesMenu = false;
                _expandedFeatureIndex = null;
              });

              _goToLogin(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: mintAccent,
              foregroundColor: darkBg2,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Get Started',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // HERO TEXT
  // ---------------------------------------------------------------------------

  Widget _buildHeroText(BuildContext context, {bool center = false}) {
    final crossAxis = center
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    final textAlign = center ? TextAlign.center : TextAlign.left;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          crossAxisAlignment: crossAxis,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: cardGlass,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome_rounded, color: mintAccent, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'For Hotels & Guests',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'Hotel stays,',
              textAlign: textAlign,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 46,
                fontWeight: FontWeight.bold,
                height: 1.1,
                letterSpacing: -1,
              ),
            ),

            Text(
              'Made Effortless',
              textAlign: textAlign,
              style: const TextStyle(
                color: mintAccent,
                fontSize: 46,
                fontWeight: FontWeight.bold,
                height: 1.1,
                letterSpacing: -1,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'One simple platform connecting hotels and their guests — from finding a stay to managing every part of the experience.',
              textAlign: textAlign,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 16,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 32),

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _guestAction(context),
                  icon: const Icon(Icons.luggage_rounded, size: 18),
                  label: const Text("I'm a Guest"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mintAccent,
                    foregroundColor: darkBg2,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showHotelOptions = !_showHotelOptions;
                    });
                  },
                  icon: Icon(
                    _showHotelOptions
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.apartment_rounded,
                    size: 18,
                  ),
                  label: const Text("I'm a Hotel"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),

            // HOTEL OPTIONS
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _showHotelOptions
                  ? Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: _buildHotelOptions(),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HOTEL OPTIONS
  // ---------------------------------------------------------------------------

  Widget _buildHotelOptions() {
    return Container(
      width: 460,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkBg.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: mintAccent.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Hotel Access',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _hotelOptionButton(
                  icon: Icons.admin_panel_settings_rounded,
                  title: 'Admin',
                  onTap: () {
                    _goToLogin(context);
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _hotelOptionButton(
                  icon: Icons.room_service_rounded,
                  title: 'Staff',
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const StaffLoginPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _hotelOptionButton(
                  icon: Icons.add_business_rounded,
                  title: 'Register',
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const HotelRegistrationPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _hotelOptionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.035),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          children: [
            Icon(icon, color: mintAccent, size: 22),

            const SizedBox(height: 7),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MAIN ANIMATION
  // ---------------------------------------------------------------------------

  Widget _build3DHotel({double height = 480}) {
    return FadeTransition(
      opacity: _fade,
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          final floatY = math.sin(_floatController.value * math.pi * 2) * 8;

          return Transform.translate(offset: Offset(0, floatY), child: child);
        },
        child: SizedBox(
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: height * 0.95,
                height: height * 0.95,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      mintAccent.withValues(alpha: 0.13),
                      mintAccent.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),

              Container(
                width: height * 0.78,
                height: height * 0.78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: mintAccent.withValues(alpha: 0.14)),
                ),
              ),

              AnimatedBuilder(
                animation: _floatController,
                builder: (context, _) {
                  final angle = _floatController.value * math.pi * 2;

                  return Transform.rotate(
                    angle: angle,
                    child: SizedBox(
                      width: height * 0.82,
                      height: height * 0.82,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 18,
                            left: height * 0.39,
                            child: _glowDot(7),
                          ),
                          Positioned(
                            right: 18,
                            top: height * 0.39,
                            child: _glowDot(5),
                          ),
                          Positioned(
                            bottom: 18,
                            left: height * 0.39,
                            child: _glowDot(6),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              Positioned(
                bottom: height * 0.06,
                child: Container(
                  width: height * 0.72,
                  height: height * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F1D16), Color(0xFF1C3226)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: mintAccent.withValues(alpha: 0.22),
                        blurRadius: 40,
                        spreadRadius: -4,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 30,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: height * 0.10,
                child: Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0012)
                    ..rotateX(0.28)
                    ..rotateZ(-0.05),
                  child: _buildingBody(height),
                ),
              ),

              Positioned(
                top: height * 0.04,
                left: 0,
                child: _floatingInfoCard(
                  icon: Icons.apartment_rounded,
                  title: 'HOTEL',
                  subtitle: 'Manage your property',
                  index: 0,
                ),
              ),

              Positioned(
                top: height * 0.20,
                right: -4,
                child: _floatingInfoCard(
                  icon: Icons.luggage_rounded,
                  title: 'GUEST',
                  subtitle: 'Enjoy your stay',
                  index: 1,
                ),
              ),

              Positioned(
                bottom: height * 0.22,
                left: -8,
                child: _floatingInfoCard(
                  icon: Icons.calendar_month_rounded,
                  title: 'BOOKING',
                  subtitle: 'Reserve with ease',
                  index: 2,
                ),
              ),

              Positioned(
                bottom: height * 0.03,
                right: 0,
                child: _floatingInfoCard(
                  icon: Icons.room_service_rounded,
                  title: 'YOUR STAY',
                  subtitle: 'Everything in one place',
                  index: 3,
                ),
              ),

              Positioned(
                top: height * 0.465,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, _) {
                    final pulse =
                        0.94 +
                        math.sin(_floatController.value * math.pi * 2) * 0.03;

                    return Transform.scale(
                      scale: pulse,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: darkBg.withValues(alpha: 0.90),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: mintAccent.withValues(alpha: 0.20),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.sync_rounded,
                              color: mintAccent,
                              size: 14,
                            ),
                            SizedBox(width: 7),
                            Text(
                              'HOTELS × GUESTS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glowDot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: mintAccent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: mintAccent.withValues(alpha: 0.7),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _floatingInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final phase = index * 0.8;

        final y = math.sin((_floatController.value * math.pi * 2) + phase) * 5;

        return Transform.translate(offset: Offset(0, y), child: child);
      },
      child: Container(
        width: 175,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: darkBg.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: mintAccent.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: mintAccent, size: 17),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 9.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildingBody(double height) {
    final buildingHeight = height * 0.62;
    final buildingWidth = height * 0.50;

    return Container(
      width: buildingWidth,
      height: buildingHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [buildingLight, buildingMid],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 50,
            offset: const Offset(0, 35),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Container(
            height: 14,
            decoration: BoxDecoration(
              color: darkBg.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: darkBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'STAYOPS',
              style: TextStyle(
                color: mintAccent,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (col) {
                    final lit = (row * 4 + col) % 3 != 0;

                    return AnimatedBuilder(
                      animation: _floatController,
                      builder: (context, _) {
                        final flicker = lit
                            ? 0.55 +
                                  0.30 *
                                      math.sin(
                                        (_floatController.value * math.pi * 2) +
                                            (row + col),
                                      )
                            : 0.0;

                        return Container(
                          width: 14,
                          height: 18,
                          decoration: BoxDecoration(
                            color: lit
                                ? windowGlow.withValues(
                                    alpha: flicker.clamp(0.30, 0.90),
                                  )
                                : darkBg.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: lit
                                ? [
                                    BoxShadow(
                                      color: windowGlow.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                    ),
                                  ]
                                : null,
                          ),
                        );
                      },
                    );
                  }),
                );
              }),
            ),
          ),

          const SizedBox(height: 10),

          Container(
            height: 22,
            decoration: BoxDecoration(
              color: darkBg.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.door_front_door_rounded,
              color: mintAccent,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HOTEL + GUEST SECTION
  // ---------------------------------------------------------------------------

  Widget _buildAudienceSection(bool isWide) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardGlass,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white12),
      ),
      child: isWide
          ? Row(
              children: [
                Expanded(
                  child: _audienceCard(
                    icon: Icons.apartment_rounded,
                    tag: 'FOR HOTELS',
                    title: 'Run your hotel, your way.',
                    description:
                        'Manage your property, rooms and bookings from one place.',
                    features: hotelFeatures,
                    filled: false,
                    onPressed: () {
                      setState(() {
                        _showHotelOptions = !_showHotelOptions;
                      });
                    },
                  ),
                ),

                Container(
                  width: 1,
                  height: 210,
                  margin: const EdgeInsets.symmetric(horizontal: 28),
                  color: Colors.white10,
                ),

                Expanded(
                  child: _audienceCard(
                    icon: Icons.luggage_rounded,
                    tag: 'FOR GUESTS',
                    title: 'Enjoy the stay, not the hassle.',
                    description:
                        'Discover, book and manage your stay with everything in one place.',
                    features: guestFeatures,
                    filled: true,
                    onPressed: () => _guestAction(context),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                _audienceCard(
                  icon: Icons.apartment_rounded,
                  tag: 'FOR HOTELS',
                  title: 'Run your hotel, your way.',
                  description:
                      'Manage your property, rooms and bookings from one place.',
                  features: hotelFeatures,
                  filled: false,
                  onPressed: () {
                    setState(() {
                      _showHotelOptions = !_showHotelOptions;
                    });
                  },
                ),

                const SizedBox(height: 24),

                Container(height: 1, color: Colors.white10),

                const SizedBox(height: 24),

                _audienceCard(
                  icon: Icons.luggage_rounded,
                  tag: 'FOR GUESTS',
                  title: 'Enjoy the stay, not the hassle.',
                  description:
                      'Discover, book and manage your stay with everything in one place.',
                  features: guestFeatures,
                  filled: true,
                  onPressed: () => _guestAction(context),
                ),
              ],
            ),
    );
  }

  Widget _audienceCard({
    required IconData icon,
    required String tag,
    required String title,
    required String description,
    required List<(IconData, String, String)> features,
    required bool filled,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: mintAccent.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: mintAccent, size: 21),
            ),

            const SizedBox(width: 12),

            Text(
              tag,
              style: const TextStyle(
                color: mintAccent,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          description,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 18),

        ...features.map(
          (feature) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(feature.$1, color: Colors.white70, size: 14),
                ),

                const SizedBox(width: 9),

                Expanded(
                  child: Text(
                    feature.$2,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: filled ? darkBg2 : Colors.white,
            backgroundColor: filled ? mintAccent : Colors.transparent,
            side: BorderSide(color: filled ? mintAccent : Colors.white24),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                filled ? 'Explore as Guest' : 'Enter as Hotel',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),

              const SizedBox(width: 7),

              const Icon(Icons.arrow_forward_rounded, size: 15),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SMALL FEATURE STRIP
  // ---------------------------------------------------------------------------

  Widget _buildFeatureStrip(bool isWide) {
    const items = [
      (
        Icons.sync_alt_rounded,
        'Connected',
        'Hotels and guests in one ecosystem',
      ),
      (Icons.bolt_rounded, 'Simple', 'Less hassle, smoother experiences'),
      (Icons.shield_outlined, 'Organized', 'Everything where it belongs'),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.025),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 40,
        runSpacing: 22,
        children: items.map((item) {
          return SizedBox(
            width: isWide ? 250 : double.infinity,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white10,
                  child: Icon(item.$1, color: mintAccent, size: 18),
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        item.$3,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ACTIONS
  // ---------------------------------------------------------------------------

  void _guestAction(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const GuestLoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _goToLogin(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
