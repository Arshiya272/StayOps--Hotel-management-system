import 'package:flutter/material.dart';

import 'guest_service_request_page.dart';
import 'guest_bill_page.dart';

class GuestDashboardPage extends StatefulWidget {
  const GuestDashboardPage({super.key});

  @override
  State<GuestDashboardPage> createState() => _GuestDashboardPageState();
}

class _GuestDashboardPageState extends State<GuestDashboardPage> {
  static const Color background = Color(0xFF13241B);
  static const Color darkCard = Color(0xFF0D1A13);
  static const Color mint = Color(0xFFB7F5C8);

  int currentIndex = 0;

  final List<RecentGuestRequest> recentRequests = [
    RecentGuestRequest(
      service: 'Water Bottle',
      room: 'Room 204',
      time: 'Yesterday',
    ),
    RecentGuestRequest(
      service: 'Room Cleaning',
      room: 'Room 204',
      time: '2 days ago',
    ),
    RecentGuestRequest(
      service: 'Extra Pillow',
      room: 'Room 204',
      time: '3 days ago',
    ),
  ];

  GuestRequest? activeRequest;

  final List<Map<String, dynamic>> quickServices = [
    {'title': 'Towels', 'icon': Icons.dry_cleaning_outlined},
    {'title': 'Cleaning', 'icon': Icons.cleaning_services_outlined},
    {'title': 'Water', 'icon': Icons.water_drop_outlined},
    {'title': 'Room Service', 'icon': Icons.room_service_outlined},
  ];

  @override
  void initState() {
    super.initState();

    activeRequest = GuestDemoStore.activeRequest;

    if (GuestDemoStore.activeRequest != null) {
      final request = GuestDemoStore.activeRequest!;

      final alreadyExists = recentRequests.any(
        (item) =>
            item.service == request.service && item.room == request.roomNumber,
      );

      if (!alreadyExists) {
        recentRequests.insert(
          0,
          RecentGuestRequest(
            service: request.service,
            room: request.roomNumber,
            time: 'Just now',
            isNew: true,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Row(
          children: [
            _buildSidebar(),
            Expanded(child: _buildMainContent()),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SIDEBAR
  // ------------------------------------------------------------

  Widget _buildSidebar() {
    return Container(
      width: 220,
      color: darkCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: mint.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.apartment_rounded,
                    color: mint,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 11),
                const Text(
                  'StayOps',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 38),

          _sideItem(Icons.grid_view_rounded, 'Home', 0),

          _sideItem(Icons.meeting_room_outlined, 'My Room', 1),

          _sideItem(Icons.room_service_outlined, 'Services', 2),

          _sideItem(Icons.receipt_long_outlined, 'My Requests', 3),

          // =========================
          // MY BILL
          // =========================
          _sideItem(Icons.receipt_long_rounded, 'My Bill', 4),

          const Spacer(),

          const Divider(color: Colors.white10, height: 1),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: mint.withOpacity(0.13),
                  child: const Text(
                    'A',
                    style: TextStyle(color: mint, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Arshiya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Guest',
                        style: TextStyle(color: Colors.white38, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.logout_rounded,
                  color: Colors.white38,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sideItem(IconData icon, String label, int index) {
    final active = currentIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: GestureDetector(
        onTap: () {
          // MY BILL
          if (index == 4) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const GuestBillPage()));
            return;
          }

          setState(() {
            currentIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          decoration: BoxDecoration(
            color: active ? mint.withOpacity(0.10) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, size: 19, color: active ? mint : Colors.white54),
              const SizedBox(width: 11),
              Text(
                label,
                style: TextStyle(
                  color: active ? Colors.white : Colors.white54,
                  fontSize: 12.5,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // MAIN CONTENT
  // ------------------------------------------------------------

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(30, 26, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(),

          const SizedBox(height: 28),

          _buildGreeting(),

          const SizedBox(height: 24),

          _buildRoomCard(),

          const SizedBox(height: 24),

          _buildRequestButton(),

          const SizedBox(height: 28),

          _buildSectionTitle(
            'Quick Services',
            'Tap a service to request it quickly.',
          ),

          const SizedBox(height: 14),

          _buildQuickServices(),

          const SizedBox(height: 30),

          _buildSectionTitle('Active Request', 'Track your current request.'),

          const SizedBox(height: 14),

          _buildActiveRequest(),

          const SizedBox(height: 30),

          _buildSectionTitle(
            'Recent Requests',
            'Your latest service activity.',
          ),

          const SizedBox(height: 14),

          _buildRecentRequests(),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // TOP BAR
  // ------------------------------------------------------------

  Widget _buildTopBar() {
    return Row(
      children: [
        const Spacer(),

        Container(
          width: 230,
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.035),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white10),
          ),
          child: const Row(
            children: [
              Icon(Icons.search_rounded, size: 17, color: Colors.white38),
              SizedBox(width: 8),
              Text(
                'Search...',
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        const Icon(
          Icons.notifications_none_rounded,
          color: Colors.white70,
          size: 22,
        ),

        const SizedBox(width: 18),

        const Icon(Icons.help_outline_rounded, color: Colors.white54, size: 20),
      ],
    );
  }

  // ------------------------------------------------------------
  // GREETING
  // ------------------------------------------------------------

  Widget _buildGreeting() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good evening, Arshiya 👋',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 7),
        Text(
          'Hope you are having a comfortable stay.',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // ROOM CARD
  // ------------------------------------------------------------

  Widget _buildRoomCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: mint.withOpacity(0.09),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.king_bed_outlined, color: mint, size: 31),
          ),

          const SizedBox(width: 16),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room 204',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Deluxe Room',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
                SizedBox(height: 7),
                Text(
                  '2 Guests  •  Check-out tomorrow',
                  style: TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: mint.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'ACTIVE STAY',
              style: TextStyle(
                color: mint,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // REQUEST BUTTON
  // ------------------------------------------------------------

  Widget _buildRequestButton() {
    return GestureDetector(
      onTap: _openServiceRequest,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: mint,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: background.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, color: background, size: 24),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request a Service',
                    style: TextStyle(
                      color: background,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Need something? Let us know.',
                    style: TextStyle(color: background, fontSize: 10),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: background,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SECTION TITLE
  // ------------------------------------------------------------

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // QUICK SERVICES
  // ------------------------------------------------------------

  Widget _buildQuickServices() {
    return Row(
      children: quickServices.map((service) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _quickServiceCard(
              service['title'] as String,
              service['icon'] as IconData,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _quickServiceCard(String title, IconData icon) {
    return GestureDetector(
      onTap: _openServiceRequest,
      child: Container(
        height: 105,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: darkCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: mint.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: mint, size: 19),
            ),
            const SizedBox(height: 9),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // ACTIVE REQUEST
  // ------------------------------------------------------------

  Widget _buildActiveRequest() {
    final request = activeRequest;

    if (request == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: darkCard,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white10),
        ),
        child: const Row(
          children: [
            Icon(Icons.room_service_outlined, color: Colors.white30, size: 22),
            SizedBox(width: 10),
            Text(
              'No active service requests.',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: mint.withOpacity(0.18)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: mint.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _serviceIcon(request.service),
                  color: mint,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.service,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.roomNumber,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amberAccent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'PENDING',
                  style: TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              _requestStep('Requested', true),
              _line(true),
              _requestStep('Assigned', false),
              _line(false),
              _requestStep('Accepted', false),
              _line(false),
              _requestStep('Completed', false),
            ],
          ),

          const SizedBox(height: 17),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.025),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Guest Remark',
                  style: TextStyle(color: Colors.white38, fontSize: 9),
                ),

                const SizedBox(height: 4),

                Text(
                  request.remark,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),

                const SizedBox(height: 10),

                const Row(
                  children: [
                    Icon(Icons.schedule_rounded, color: mint, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Waiting for assignment',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _deleteActiveRequest,
                    icon: const Icon(Icons.delete_outline_rounded, size: 17),
                    label: const Text('Cancel Request'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent.shade100,
                      side: BorderSide(
                        color: Colors.redAccent.withOpacity(0.25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _requestStep(String label, bool active) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 17,
            height: 17,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? mint : Colors.transparent,
              border: Border.all(
                color: active ? mint : Colors.white24,
                width: 2,
              ),
            ),
            child: active
                ? const Icon(Icons.check, size: 10, color: background)
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white60 : Colors.white30,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(bool active) {
    return Expanded(
      child: Container(
        height: 1,
        color: active ? mint.withOpacity(0.5) : Colors.white12,
      ),
    );
  }

  // ------------------------------------------------------------
  // RECENT REQUESTS
  // ------------------------------------------------------------

  Widget _buildRecentRequests() {
    return Container(
      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: recentRequests.asMap().entries.map((entry) {
          final index = entry.key;
          final request = entry.value;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: index == recentRequests.length - 1
                  ? null
                  : const Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: mint.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    request.isNew
                        ? Icons.schedule_rounded
                        : Icons.check_circle_outline_rounded,
                    color: request.isNew ? Colors.amberAccent : mint,
                    size: 18,
                  ),
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.service,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${request.room}  •  ${request.time}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  request.isNew ? 'Pending' : 'Completed',
                  style: TextStyle(
                    color: request.isNew ? Colors.amberAccent : mint,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ------------------------------------------------------------
  // HELPERS
  // ------------------------------------------------------------

  IconData _serviceIcon(String service) {
    final value = service.toLowerCase();

    if (value.contains('towel')) {
      return Icons.dry_cleaning_outlined;
    }

    if (value.contains('clean')) {
      return Icons.cleaning_services_outlined;
    }

    if (value.contains('water')) {
      return Icons.water_drop_outlined;
    }

    if (value.contains('pillow')) {
      return Icons.bed_outlined;
    }

    if (value.contains('room service')) {
      return Icons.room_service_outlined;
    }

    return Icons.room_service_outlined;
  }

  // ------------------------------------------------------------
  // OPEN SERVICE REQUEST
  // ------------------------------------------------------------

  Future<void> _openServiceRequest() async {
    final GuestRequest? request = await Navigator.of(context)
        .push<GuestRequest>(
          MaterialPageRoute(
            builder: (context) => const GuestServiceRequestPage(),
          ),
        );

    if (!mounted || request == null) {
      return;
    }

    setState(() {
      activeRequest = request;

      GuestDemoStore.activeRequest = request;

      recentRequests.insert(
        0,
        RecentGuestRequest(
          service: request.service,
          room: request.roomNumber,
          time: 'Just now',
          isNew: true,
        ),
      );
    });
  }

  // ------------------------------------------------------------
  // DELETE / CANCEL REQUEST
  // ------------------------------------------------------------

  Future<void> _deleteActiveRequest() async {
    final request = activeRequest;

    if (request == null) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Cancel this request?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'The service request will be removed from your active requests.',
            style: TextStyle(color: Colors.white60, fontSize: 12, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'Keep Request',
                style: TextStyle(color: Colors.white60),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'Cancel Request',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldDelete != true) {
      return;
    }

    setState(() {
      activeRequest = null;
      GuestDemoStore.activeRequest = null;

      recentRequests.removeWhere(
        (item) =>
            item.isNew &&
            item.service == request.service &&
            item.room == request.roomNumber,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Service request cancelled.'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

// ------------------------------------------------------------
// LOCAL DEMO STORE
// ------------------------------------------------------------

class GuestDemoStore {
  static GuestRequest? activeRequest;
}

// ------------------------------------------------------------
// RECENT REQUEST MODEL
// ------------------------------------------------------------

class RecentGuestRequest {
  final String service;
  final String room;
  final String time;
  final bool isNew;

  const RecentGuestRequest({
    required this.service,
    required this.room,
    required this.time,
    this.isNew = false,
  });
}
