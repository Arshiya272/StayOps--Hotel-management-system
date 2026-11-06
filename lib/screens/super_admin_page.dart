import 'package:flutter/material.dart';

import '../models/hotel_registration.dart';
import '../models/hotel_registration_store.dart';

class SuperAdminPage extends StatefulWidget {
  const SuperAdminPage({super.key});

  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  final Color darkBg = const Color(0xFF13241B);
  final Color darkBg2 = const Color(0xFF0D1A13);
  final Color mintAccent = const Color(0xFFB7F5C8);
  final Color sidebarBg = const Color(0xFF0F1E17);

  int selectedIndex = 0;

  List<HotelRegistration> get hotelRequests =>
      HotelRegistrationStore.instance.registrations;

  final List<Map<String, dynamic>> approvedHotels = [
    {
      'hotelId': 'STY-HOT-0001',
      'hotelName': 'Lake View Residency',
      'location': 'Coimbatore, Tamil Nadu',
      'adminId': 'STY-ADM-0001',
      'rooms': '42',
      'status': 'Active',
    },
    {
      'hotelId': 'STY-HOT-0002',
      'hotelName': 'Royal Palm Hotel',
      'location': 'Bangalore, Karnataka',
      'adminId': 'STY-ADM-0002',
      'rooms': '65',
      'status': 'Active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: selectedIndex == 0
                      ? _buildDashboard()
                      : selectedIndex == 1
                      ? _buildRequestsPage()
                      : selectedIndex == 2
                      ? _buildApprovedHotelsPage()
                      : _buildSettingsPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIDEBAR
  // ============================================================

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: sidebarBg,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            Row(
              children: [
                const SizedBox(width: 24),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: mintAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.shield_rounded, color: darkBg, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'STAYOPS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.only(left: 78),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SUPER ADMIN',
                  style: TextStyle(
                    color: mintAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            _sideItem(Icons.dashboard_outlined, 'Dashboard', 0),

            _sideItem(
              Icons.pending_actions_outlined,
              'Hotel Requests',
              1,
              badge: hotelRequests
                  .where((e) => e.status == 'Pending')
                  .length
                  .toString(),
            ),

            _sideItem(Icons.business_outlined, 'Approved Hotels', 2),

            _sideItem(Icons.settings_outlined, 'Settings', 3),

            const Spacer(),

            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: darkBg2,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: mintAccent,
                    child: Icon(Icons.person, color: darkBg),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Main Admin',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Platform Owner',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _sideItem(IconData icon, String title, int index, {String? badge}) {
    final bool selected = selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: selected ? mintAccent.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(color: mintAccent.withOpacity(0.16))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? mintAccent : Colors.white.withOpacity(0.55),
              size: 21,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : Colors.white.withOpacity(0.62),
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: mintAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: darkBg,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: darkBg,
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      child: Row(
        children: [
          Text(
            _pageTitle(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_rounded,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 8),
          Container(width: 1, height: 28, color: Colors.white.withOpacity(0.1)),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 19,
            child: Icon(Icons.admin_panel_settings),
          ),
          const SizedBox(width: 10),
          const Text(
            'Main Admin',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _pageTitle() {
    switch (selectedIndex) {
      case 1:
        return 'Hotel Registration Requests';
      case 2:
        return 'Approved Hotels';
      case 3:
        return 'Settings';
      default:
        return 'Super Admin Dashboard';
    }
  }

  // ============================================================
  // DASHBOARD
  // ============================================================

  Widget _buildDashboard() {
    final pending = hotelRequests.where((e) => e.status == 'Pending').length;

    final approvedRegistrations = hotelRequests
        .where((e) => e.status == 'Approved')
        .length;

    final totalHotels = approvedHotels.length + approvedRegistrations;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good morning, Main Admin 👋',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Platform Overview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: _statCard(
                  Icons.business_outlined,
                  'Total Hotels',
                  totalHotels.toString(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _statCard(
                  Icons.pending_actions_outlined,
                  'Pending Requests',
                  pending.toString(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _statCard(
                  Icons.verified_outlined,
                  'Active Hotels',
                  totalHotels.toString(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _statCard(
                  Icons.warning_amber_rounded,
                  'Requires Review',
                  pending.toString(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildRecentRequests()),
              const SizedBox(width: 22),
              Expanded(flex: 2, child: _buildPlatformCard()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkBg2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: mintAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: mintAccent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRequests() {
    final pendingRequests = hotelRequests
        .where((request) => request.status == 'Pending')
        .take(3)
        .toList();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: darkBg2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'New Hotel Registrations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
                child: Text('View All', style: TextStyle(color: mintAccent)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (pendingRequests.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Text(
                'No pending hotel registrations.',
                style: TextStyle(color: Colors.white.withOpacity(0.4)),
              ),
            )
          else
            ...pendingRequests.map((request) => _requestTile(request)),
        ],
      ),
    );
  }

  Widget _requestTile(HotelRegistration request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: darkBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: mintAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.business_rounded, color: mintAccent),
          ),
          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.hotelName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${request.city}, ${request.state}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Pending',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(width: 12),

          IconButton(
            onPressed: () {
              _showRequestDetails(request);
            },
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withOpacity(0.45),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: mintAccent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.security_rounded, color: darkBg, size: 30),
          const SizedBox(height: 18),

          Text(
            'Platform Security',
            style: TextStyle(
              color: darkBg,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Only verified and approved hotels can access StayOps.',
            style: TextStyle(
              color: darkBg.withOpacity(0.7),
              height: 1.5,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 20),

          _securityPoint('Hotel verification'),
          _securityPoint('Unique Hotel ID'),
          _securityPoint('Admin credentials'),
          _securityPoint('Controlled access'),
        ],
      ),
    );
  }

  Widget _securityPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: darkBg, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: darkBg,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REQUESTS PAGE
  // ============================================================

  Widget _buildRequestsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review hotels before granting access.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 24),

          if (hotelRequests.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: darkBg2,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Center(
                child: Text(
                  'No hotel registration requests yet.',
                  style: TextStyle(color: Colors.white.withOpacity(0.4)),
                ),
              ),
            )
          else
            ...hotelRequests.map((request) => _largeRequestCard(request)),
        ],
      ),
    );
  }

  Widget _largeRequestCard(HotelRegistration request) {
    final bool pending = request.status == 'Pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: darkBg2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: mintAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.hotel_rounded, color: mintAccent, size: 28),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.hotelName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '${request.city}, ${request.state}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Owner: ${request.ownerManager}  •  ${request.numberOfRooms} rooms',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Request ID: ${request.id}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          if (pending) ...[
            OutlinedButton(
              onPressed: () {
                _showRequestDetails(request);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withOpacity(0.15)),
              ),
              child: const Text('View Details'),
            ),

            const SizedBox(width: 10),

            ElevatedButton(
              onPressed: () {
                _approveHotel(request);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mintAccent,
                foregroundColor: darkBg,
              ),
              child: const Text('Approve'),
            ),

            const SizedBox(width: 8),

            OutlinedButton(
              onPressed: () {
                _rejectHotel(request);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
              ),
              child: const Text('Reject'),
            ),
          ] else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: request.status == 'Approved'
                    ? mintAccent.withOpacity(0.1)
                    : Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                request.status,
                style: TextStyle(
                  color: request.status == 'Approved'
                      ? mintAccent
                      : Colors.redAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // APPROVED HOTELS
  // ============================================================

  Widget _buildApprovedHotelsPage() {
    final List<Map<String, dynamic>> allApprovedHotels = [
      ...approvedHotels,
      ...hotelRequests
          .where((registration) => registration.status == 'Approved')
          .map(
            (registration) => {
              'hotelId': registration.hotelId ?? '',
              'hotelName': registration.hotelName,
              'location': '${registration.city}, ${registration.state}',
              'adminId': registration.adminId ?? '',
              'rooms': registration.numberOfRooms,
              'status': 'Active',
            },
          ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hotels currently approved to use StayOps.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 24),

          if (allApprovedHotels.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: darkBg2,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Center(
                child: Text(
                  'No approved hotels yet.',
                  style: TextStyle(color: Colors.white.withOpacity(0.4)),
                ),
              ),
            )
          else
            ...allApprovedHotels.map(
              (hotel) => Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: darkBg2,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: mintAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.verified_rounded, color: mintAccent),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotel['hotelName'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            hotel['location'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.45),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    _infoColumn('Hotel ID', hotel['hotelId']),

                    const SizedBox(width: 30),

                    _infoColumn('Admin ID', hotel['adminId']),

                    const SizedBox(width: 30),

                    _infoColumn('Rooms', hotel['rooms']),

                    const SizedBox(width: 25),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: mintAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Active',
                        style: TextStyle(
                          color: mintAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SETTINGS
  // ============================================================

  Widget _buildSettingsPage() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Super Admin Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 22),

          _settingTile(
            Icons.admin_panel_settings_outlined,
            'Admin Account',
            'Manage Super Admin credentials',
          ),

          _settingTile(
            Icons.security_outlined,
            'Security',
            'Platform access and security controls',
          ),

          _settingTile(
            Icons.email_outlined,
            'Email Notifications',
            'Hotel approval and registration notifications',
          ),
        ],
      ),
    );
  }

  Widget _settingTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: darkBg2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Icon(icon, color: mintAccent),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // APPROVE / REJECT
  // ============================================================

  void _approveHotel(HotelRegistration request) {
    final int nextNumber =
        HotelRegistrationStore.instance.registrations
            .where((registration) => registration.hotelId != null)
            .length +
        1;

    final String hotelId = 'STY-HOT-${nextNumber.toString().padLeft(4, '0')}';

    final String adminId = 'STY-ADM-${nextNumber.toString().padLeft(4, '0')}';

    final String temporaryPassword = 'Stay@${DateTime.now().year}';

    HotelRegistrationStore.instance.approveRegistration(
      id: request.id,
      hotelId: hotelId,
      adminId: adminId,
      adminPassword: temporaryPassword,
    );

    setState(() {
      approvedHotels.add({
        'hotelId': hotelId,
        'hotelName': request.hotelName,
        'location': '${request.city}, ${request.state}',
        'adminId': adminId,
        'rooms': request.numberOfRooms,
        'status': 'Active',
      });
    });

    _showApprovalDialog(request, hotelId, adminId);
  }

  void _rejectHotel(HotelRegistration request) {
    HotelRegistrationStore.instance.rejectRegistration(request.id);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${request.hotelName} has been rejected.'),
        backgroundColor: darkBg2,
      ),
    );
  }

  // ============================================================
  // DETAILS DIALOG
  // ============================================================

  void _showRequestDetails(HotelRegistration request) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: darkBg2,
          title: const Text(
            'Hotel Registration',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),

          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailRow('Hotel Name', request.hotelName),

                  _detailRow('Owner / Manager', request.ownerManager),

                  _detailRow('Address', request.address),

                  _detailRow('City', request.city),

                  _detailRow('State', request.state),

                  _detailRow('PIN Code', request.pinCode),

                  _detailRow('Number of Rooms', request.numberOfRooms),

                  _detailRow('Phone', request.phone),

                  _detailRow('Official Email', request.officialEmail),

                  _detailRow(
                    'Website',
                    request.website.isEmpty ? 'Not provided' : request.website,
                  ),

                  _detailRow(
                    'Registration / License No.',
                    request.registrationNumber,
                  ),

                  _detailRow(
                    'Verification Details',
                    request.verificationDetails.isEmpty
                        ? 'Not provided'
                        : request.verificationDetails,
                  ),

                  _detailRow('Submitted', _formatDate(request.submittedAt)),

                  _detailRow('Request ID', request.id),

                  _detailRow('Status', request.status),
                ],
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close', style: TextStyle(color: mintAccent)),
            ),

            if (request.status == 'Pending')
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _approveHotel(request);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mintAccent,
                  foregroundColor: darkBg,
                ),
                child: const Text('Approve Hotel'),
              ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 165,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} '
        '${_monthName(date.month)} '
        '${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }

  // ============================================================
  // APPROVAL EMAIL DEMO
  // ============================================================

  void _showApprovalDialog(
    HotelRegistration request,
    String hotelId,
    String adminId,
  ) {
    final String temporaryPassword =
        request.adminPassword ?? 'Stay@${DateTime.now().year}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: darkBg2,

          title: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: mintAccent),
              const SizedBox(width: 10),
              const Text(
                'Hotel Approved',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.hotelName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'The hotel has been approved and its Hotel Admin account has been created.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 22),

                  _credentialRow('Hotel ID', hotelId),

                  _credentialRow('Admin ID', adminId),

                  _credentialRow('Admin Password', temporaryPassword),

                  _credentialRow('Official Email', request.officialEmail),

                  const SizedBox(height: 15),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: mintAccent.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.email_outlined, color: mintAccent),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            'Credentials will be sent to the registered hotel email.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.65),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Email sending is currently simulated in the frontend. Real email delivery will be connected when Firebase/backend integration is added.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mintAccent,
                foregroundColor: darkBg,
              ),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Widget _credentialRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 145,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: darkBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: mintAccent,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
