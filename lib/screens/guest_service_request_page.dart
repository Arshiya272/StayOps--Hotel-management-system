import 'package:flutter/material.dart';

import '../models/service_request.dart';
import '../models/service_request_store.dart';

class GuestRequest {
  final String service;
  final String remark;
  final String roomNumber;
  final DateTime createdAt;

  GuestRequest({
    required this.service,
    required this.remark,
    required this.roomNumber,
    required this.createdAt,
  });
}

class GuestServiceRequestPage extends StatefulWidget {
  const GuestServiceRequestPage({super.key});

  @override
  State<GuestServiceRequestPage> createState() =>
      _GuestServiceRequestPageState();
}

class _GuestServiceRequestPageState extends State<GuestServiceRequestPage> {
  static const Color background = Color(0xFF13241B);
  static const Color darkCard = Color(0xFF0D1A13);
  static const Color mint = Color(0xFFB7F5C8);

  final TextEditingController remarkController = TextEditingController();

  int? selectedService;

  final List<Map<String, dynamic>> services = [
    {
      'title': 'Extra Towels',
      'subtitle': 'Need fresh towels',
      'icon': Icons.dry_cleaning_outlined,
    },
    {
      'title': 'Room Cleaning',
      'subtitle': 'Request room cleaning',
      'icon': Icons.cleaning_services_outlined,
    },
    {
      'title': 'Water',
      'subtitle': 'Bottles or drinking water',
      'icon': Icons.water_drop_outlined,
    },
    {
      'title': 'Room Service',
      'subtitle': 'Food and dining requests',
      'icon': Icons.room_service_outlined,
    },
    {
      'title': 'Extra Pillow',
      'subtitle': 'Need an extra pillow',
      'icon': Icons.bed_outlined,
    },
    {
      'title': 'Other',
      'subtitle': 'Something else',
      'icon': Icons.more_horiz_rounded,
    },
  ];

  @override
  void dispose() {
    remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: darkCard,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Request a Service',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                const SizedBox(height: 28),

                _buildRoomInfo(),

                const SizedBox(height: 28),

                const Text(
                  'What do you need?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Choose a service and tell us what you need.',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),

                const SizedBox(height: 18),

                _buildServices(),

                const SizedBox(height: 28),

                _buildRemarkSection(),

                const SizedBox(height: 28),

                _buildSendButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How can we help?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 7),
        Text(
          'Request anything you need during your stay.',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // ROOM INFO
  // ------------------------------------------------------------

  Widget _buildRoomInfo() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: mint.withOpacity(0.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.meeting_room_outlined,
              color: mint,
              size: 24,
            ),
          ),

          const SizedBox(width: 14),

          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Room 204',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Deluxe Room  •  2 Guests',
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
  // SERVICES
  // ------------------------------------------------------------

  Widget _buildServices() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 2.15,
      ),
      itemBuilder: (context, index) {
        final service = services[index];

        final bool selected = selectedService == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedService = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: selected ? mint.withOpacity(0.08) : darkCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? mint.withOpacity(0.55) : Colors.white10,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: selected
                        ? mint.withOpacity(0.12)
                        : Colors.white.withOpacity(0.035),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    service['icon'] as IconData,
                    color: selected ? mint : Colors.white54,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['title'] as String,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        service['subtitle'] as String,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),

                if (selected)
                  const Icon(Icons.check_circle_rounded, color: mint, size: 17),
              ],
            ),
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // REMARK
  // ------------------------------------------------------------

  Widget _buildRemarkSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add a remark',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          'Give the service team any additional details.',
          style: TextStyle(color: Colors.white38, fontSize: 11),
        ),

        const SizedBox(height: 13),

        TextField(
          controller: remarkController,
          maxLines: 5,
          cursorColor: mint,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          decoration: InputDecoration(
            hintText: 'Example: Please bring 2 towels to the room.',
            hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
            filled: true,
            fillColor: darkCard,
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: mint, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // SEND BUTTON
  // ------------------------------------------------------------

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _sendRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: mint,
          foregroundColor: background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_rounded, size: 18),
            SizedBox(width: 8),
            Text(
              'Send Request',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SEND
  // ------------------------------------------------------------

  void _sendRequest() {
    if (selectedService == null) {
      _showMessage('Please select a service first.');
      return;
    }

    final String remark = remarkController.text.trim();

    if (remark.isEmpty) {
      _showMessage('Please add a remark for the service team.');
      return;
    }

    final String service = services[selectedService!]['title'] as String;

    final DateTime now = DateTime.now();

    final String requestId = 'SR-${now.millisecondsSinceEpoch}';

    // Create the shared request.
    final ServiceRequest request = ServiceRequest(
      id: requestId,
      guestName: 'Arshiya',
      roomNumber: '204',
      serviceType: service,
      remark: remark,
      createdAt: now,
    );

    // Add it to the shared local store.
    ServiceRequestStore.instance.addRequest(request);

    // Keep the existing confirmation UI working.
    final GuestRequest oldRequest = GuestRequest(
      service: service,
      remark: remark,
      roomNumber: '204',
      createdAt: now,
    );

    _showRequestConfirmation(oldRequest, requestId);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // ------------------------------------------------------------
  // CONFIRMATION
  // ------------------------------------------------------------

  void _showRequestConfirmation(GuestRequest request, String requestId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: mint.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: mint, size: 34),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Request Sent',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Your request has been received by the hotel team.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.025),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _confirmationRow('Service', request.service),

                      const SizedBox(height: 10),

                      _confirmationRow('Room', request.roomNumber),

                      const SizedBox(height: 10),

                      _confirmationRow('Status', 'Waiting for assignment'),

                      const SizedBox(height: 10),

                      _confirmationRow('Request ID', '#$requestId'),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context, request);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mint,
                      foregroundColor: background,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _confirmationRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ),

        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
