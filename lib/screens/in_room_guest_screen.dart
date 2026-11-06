import 'package:flutter/material.dart';

import '../models/service_request.dart';
import '../models/service_request_store.dart';
import 'guest_bill_page.dart';

class InRoomGuestScreen extends StatefulWidget {
  final String roomNumber;
  final String guestName;

  const InRoomGuestScreen({
    super.key,
    this.roomNumber = '204',
    this.guestName = 'Guest',
  });

  @override
  State<InRoomGuestScreen> createState() => _InRoomGuestScreenState();
}

class _InRoomGuestScreenState extends State<InRoomGuestScreen> {
  final TextEditingController _requestController = TextEditingController();

  final List<String> _quickServices = [
    'Room Cleaning',
    'Towels',
    'Extra Water',
    'Toiletries',
    'Extra Bed',
    'Extra Blanket',
  ];

  @override
  void dispose() {
    _requestController.dispose();
    super.dispose();
  }

  void _sendRequest([String? quickRequest]) {
    final text = (quickRequest ?? _requestController.text).trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a request first.')),
      );
      return;
    }

    final request = ServiceRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      guestName: widget.guestName,
      roomNumber: widget.roomNumber,
      serviceType: 'Guest Request',
      remark: text,
      createdAt: DateTime.now(),
    );

    ServiceRequestStore.instance.addRequest(request);

    _requestController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request sent to the hotel.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<ServiceRequest> _roomRequests() {
    return ServiceRequestStore.instance.requests
        .where(
          (request) =>
              request.roomNumber == widget.roomNumber &&
              request.guestName == widget.guestName,
        )
        .toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Assigned':
        return Colors.blue;
      case 'In Progress':
        return Colors.deepPurple;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.schedule_rounded;
      case 'Assigned':
        return Icons.person_pin_rounded;
      case 'In Progress':
        return Icons.autorenew_rounded;
      case 'Completed':
        return Icons.check_circle_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13241B),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: ServiceRequestStore.instance,
          builder: (context, _) {
            final requests = _roomRequests();

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 1000;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 55 : 24,
                    vertical: 28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopBar(),

                      const SizedBox(height: 35),

                      _buildWelcomeCard(),

                      const SizedBox(height: 28),

                      _buildSectionTitle(
                        'How can we help you?',
                        'Request anything you need during your stay.',
                      ),

                      const SizedBox(height: 18),

                      _buildQuickServices(),

                      const SizedBox(height: 30),

                      _buildCustomRequest(),

                      const SizedBox(height: 30),

                      _buildActionCards(),

                      const SizedBox(height: 32),

                      _buildSectionTitle(
                        'Your Requests',
                        'Track the requests you have sent to the hotel.',
                      ),

                      const SizedBox(height: 18),

                      if (requests.isEmpty)
                        _buildEmptyRequests()
                      else
                        ...requests.map(_buildRequestCard),

                      const SizedBox(height: 35),

                      _buildFooter(),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFB7F5C8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.hotel_rounded,
            color: Color(0xFF13241B),
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'STAYOPS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              'Your digital hotel concierge',
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.meeting_room_rounded,
                color: Color(0xFFB7F5C8),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Room ${widget.roomNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF203A2B), Color(0xFF172D22)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: const Color(0xFFB7F5C8).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.waving_hand_rounded,
              color: Color(0xFFB7F5C8),
              size: 34,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${widget.guestName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Everything you need is right here. '
                  'Request a service or let us know what you need.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildQuickServices() {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: _quickServices.map((service) {
        return InkWell(
          onTap: () => _sendRequest(service),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: 190,
            height: 110,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1E17),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.07)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  _serviceIcon(service),
                  color: const Color(0xFFB7F5C8),
                  size: 27,
                ),
                Text(
                  service,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _serviceIcon(String service) {
    if (service.contains('Cleaning')) {
      return Icons.cleaning_services_rounded;
    }

    if (service.contains('Towels')) {
      return Icons.dry_cleaning_rounded;
    }

    if (service.contains('Water')) {
      return Icons.water_drop_rounded;
    }

    if (service.contains('Toiletries')) {
      return Icons.spa_rounded;
    }

    if (service.contains('Bed')) {
      return Icons.bed_rounded;
    }

    return Icons.airline_seat_flat_rounded;
  }

  Widget _buildCustomRequest() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1E17),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.edit_rounded, color: Color(0xFFB7F5C8)),
              SizedBox(width: 10),
              Text(
                'Write your own request',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _requestController,
            minLines: 2,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Example: I need 2 towels and a bottle of water',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF13241B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(18),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 54,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _sendRequest,
              icon: const Icon(Icons.send_rounded),
              label: const Text(
                'SEND REQUEST',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB7F5C8),
                foregroundColor: const Color(0xFF13241B),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            icon: Icons.receipt_long_rounded,
            title: 'My Bill',
            subtitle: 'View your current stay charges',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GuestBillPage()),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            icon: Icons.room_service_rounded,
            title: 'Need Help?',
            subtitle: 'Send a custom request to reception',
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1E17),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFB7F5C8).withOpacity(0.12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: const Color(0xFFB7F5C8), size: 26),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white30,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRequests() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1E17),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: Color(0xFFB7F5C8),
            size: 42,
          ),
          SizedBox(height: 12),
          Text(
            'No requests yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Your requests will appear here.',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(ServiceRequest request) {
    final statusColor = _statusColor(request.status);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1E17),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_statusIcon(request.status), color: statusColor),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.remark,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  request.assignedStaffName == null
                      ? 'Waiting for hotel staff'
                      : 'Assigned to ${request.assignedStaffName}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              request.status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text(
        'StayOps • Your stay, simplified.',
        style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 12),
      ),
    );
  }
}
