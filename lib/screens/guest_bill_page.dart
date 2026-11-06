import 'package:flutter/material.dart';

class GuestBillPage extends StatelessWidget {
  const GuestBillPage({super.key});

  static const Color darkBg = Color(0xFF13241B);
  static const Color darkBg2 = Color(0xFF0D1A13);
  static const Color mintAccent = Color(0xFFB7F5C8);

  final double roomCharge = 4000;
  final double extraBed = 500;
  final double otherCharges = 0;
  final double discount = 250;
  final double tax = 450;

  static const List<Map<String, dynamic>> serviceCharges = [
    {'service': 'Room Service', 'description': 'Breakfast', 'amount': 500.0},
    {'service': 'Laundry', 'description': 'Clothes washing', 'amount': 250.0},
    {
      'service': 'Extra Towels',
      'description': 'Additional towels',
      'amount': 0.0,
    },
  ];

  double get serviceTotal {
    return serviceCharges.fold(
      0.0,
      (sum, item) => sum + (item['amount'] as double),
    );
  }

  double get subtotal {
    return roomCharge + extraBed + serviceTotal + otherCharges;
  }

  double get grandTotal {
    return subtotal - discount + tax;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 28),
                  _buildBookingInfo(),
                  const SizedBox(height: 20),
                  _buildRoomCharges(),
                  const SizedBox(height: 20),
                  _buildServiceCharges(),
                  const SizedBox(height: 20),
                  _buildBillSummary(),
                  const SizedBox(height: 22),
                  _buildPaymentStatus(),
                  const SizedBox(height: 24),
                  _buildInvoiceButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white70),
        ),
        const SizedBox(width: 8),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: mintAccent.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.receipt_long_rounded,
            color: mintAccent,
            size: 24,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Bill',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Your current stay charges',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingInfo() {
    return _card(
      child: Row(
        children: [
          Expanded(
            child: _infoItem(
              Icons.confirmation_number_outlined,
              'Booking ID',
              'BK-001',
            ),
          ),
          Expanded(
            child: _infoItem(Icons.meeting_room_outlined, 'Room', '204'),
          ),
          Expanded(
            child: _infoItem(Icons.login_rounded, 'Check-in', '17 Sep 2026'),
          ),
          Expanded(
            child: _infoItem(Icons.logout_rounded, 'Check-out', '19 Sep 2026'),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: mintAccent, size: 20),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoomCharges() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.bed_outlined, 'Room Charges'),
          const SizedBox(height: 18),
          _chargeRow('Room 204', '2 nights', roomCharge),
          const SizedBox(height: 12),
          _chargeRow('Extra Bed', '1', extraBed),
        ],
      ),
    );
  }

  Widget _buildServiceCharges() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.room_service_outlined, 'Service Requests'),
          const SizedBox(height: 18),
          ...serviceCharges.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _chargeRow(
                item['service'] as String,
                item['description'] as String,
                item['amount'] as double,
              ),
            );
          }),
          const Divider(color: Colors.white12, height: 24),
          _chargeRow('Service Total', '', serviceTotal, bold: true),
        ],
      ),
    );
  }

  Widget _buildBillSummary() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.calculate_outlined, 'Bill Summary'),
          const SizedBox(height: 20),
          _summaryRow('Room Charges', roomCharge),
          _summaryRow('Extra Bed', extraBed),
          _summaryRow('Service Charges', serviceTotal),
          _summaryRow('Other Charges', otherCharges),
          const Divider(color: Colors.white12, height: 28),
          _summaryRow('Subtotal', subtotal, bold: true),
          _summaryRow('Discount', -discount),
          _summaryRow('Tax', tax),
          const Divider(color: Colors.white12, height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grand Total',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '₹${grandTotal.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: mintAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pending_actions_rounded,
              color: Colors.orangeAccent,
              size: 21,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Pending',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Payment will be collected during checkout.',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '₹${grandTotal.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () {
          _showInvoiceDialog(context);
        },
        icon: const Icon(Icons.picture_as_pdf_outlined, color: darkBg),
        label: const Text(
          'View Invoice',
          style: TextStyle(
            color: darkBg,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: mintAccent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  void _showInvoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkBg2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.receipt_long_rounded, color: mintAccent),
              SizedBox(width: 10),
              Text(
                'Invoice',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your invoice has been generated.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: mintAccent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₹${grandTotal.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: mintAccent,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close', style: TextStyle(color: mintAccent)),
            ),
          ],
        );
      },
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.035),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: mintAccent, size: 20),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _chargeRow(
    String title,
    String subtitle,
    double amount, {
    bool bold = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ],
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(
            color: bold ? mintAccent : Colors.white70,
            fontSize: 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String title, double amount, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: bold ? Colors.white : Colors.white54,
              fontSize: 13,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: bold ? Colors.white : Colors.white70,
              fontSize: 13,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
