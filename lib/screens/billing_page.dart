import 'package:flutter/material.dart';
import '../widgets/app_shell.dart';

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  static const darkBg2 = Color(0xFF0D1A13);
  static const mintAccent = Color(0xFFB7F5C8);
  static const cardGlass = Color(0x1AFFFFFF);

  // ===============================================================
  // DUMMY BILL DATA
  // ===============================================================

  final List<Map<String, dynamic>> bills = [
    {
      'billId': 'BILL-001',
      'guest': 'Guest 01',
      'room': '204',
      'bookingId': 'BK-001',
      'roomCharge': 4000.0,
      'extraBed': 500.0,
      'services': [
        {'name': 'Room Service', 'amount': 500.0},
        {'name': 'Laundry', 'amount': 250.0},
      ],
      'otherCharges': 0.0,
      'discount': 250.0,
      'tax': 450.0,
      'status': 'Pending',
      'date': '17 Sep 2026',
    },
    {
      'billId': 'BILL-002',
      'guest': 'Guest 02',
      'room': '108',
      'bookingId': 'BK-002',
      'roomCharge': 3500.0,
      'extraBed': 0.0,
      'services': [
        {'name': 'Room Service', 'amount': 500.0},
      ],
      'otherCharges': 0.0,
      'discount': 0.0,
      'tax': 360.0,
      'status': 'Paid',
      'date': '17 Sep 2026',
    },
    {
      'billId': 'BILL-003',
      'guest': 'Guest 03',
      'room': '302',
      'bookingId': 'BK-003',
      'roomCharge': 5000.0,
      'extraBed': 500.0,
      'services': [
        {'name': 'Laundry', 'amount': 300.0},
      ],
      'otherCharges': 200.0,
      'discount': 300.0,
      'tax': 570.0,
      'status': 'Pending',
      'date': '16 Sep 2026',
    },
    {
      'billId': 'BILL-004',
      'guest': 'Guest 04',
      'room': '215',
      'bookingId': 'BK-004',
      'roomCharge': 3000.0,
      'extraBed': 0.0,
      'services': [
        {'name': 'Room Service', 'amount': 450.0},
      ],
      'otherCharges': 0.0,
      'discount': 0.0,
      'tax': 345.0,
      'status': 'Paid',
      'date': '15 Sep 2026',
    },
  ];

  // ===============================================================
  // BUILD
  // ===============================================================

  @override
  Widget build(BuildContext context) {
    final totalRevenue = bills.fold<double>(
      0,
      (sum, bill) => sum + _calculateTotal(bill),
    );

    final pendingBills = bills
        .where((bill) => bill['status'] == 'Pending')
        .toList();

    final paidBills = bills.where((bill) => bill['status'] == 'Paid').toList();

    final pendingAmount = pendingBills.fold<double>(
      0,
      (sum, bill) => sum + _calculateTotal(bill),
    );

    final paidAmount = paidBills.fold<double>(
      0,
      (sum, bill) => sum + _calculateTotal(bill),
    );

    return AppShell(
      currentSection: AppSection.billing,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =======================================================
            // HEADER
            // =======================================================
            const Text(
              'Billing',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Manage guest bills, payments and charges',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),

            const SizedBox(height: 28),

            // =======================================================
            // STAT CARDS
            // =======================================================
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;

                final cards = [
                  _statCard(
                    'Total Bills',
                    '${bills.length}',
                    Icons.receipt_long_outlined,
                    mintAccent,
                  ),
                  _statCard(
                    'Total Revenue',
                    _money(totalRevenue),
                    Icons.account_balance_wallet_outlined,
                    Colors.greenAccent,
                  ),
                  _statCard(
                    'Pending Payments',
                    _money(pendingAmount),
                    Icons.pending_actions_outlined,
                    Colors.amber,
                  ),
                  _statCard(
                    'Paid Amount',
                    _money(paidAmount),
                    Icons.check_circle_outline_rounded,
                    Colors.lightBlueAccent,
                  ),
                ];

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: cards.map((card) {
                    return SizedBox(
                      width: isWide
                          ? (constraints.maxWidth - 48) / 4
                          : constraints.maxWidth,
                      child: card,
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 32),

            // =======================================================
            // RECENT BILLS
            // =======================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardGlass,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Bills',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'View and manage guest billing details',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),

                  const SizedBox(height: 20),

                  // Desktop table
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 800) {
                        return _desktopBillTable();
                      }

                      return _mobileBillList();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // DESKTOP BILL TABLE
  // ===============================================================

  Widget _desktopBillTable() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Expanded(flex: 2, child: Text('Guest', style: _headerStyle)),
              Expanded(child: Text('Room', style: _headerStyle)),
              Expanded(flex: 2, child: Text('Bill ID', style: _headerStyle)),
              Expanded(child: Text('Total', style: _headerStyle)),
              Expanded(child: Text('Status', style: _headerStyle)),
              SizedBox(width: 50, child: Text('')),
            ],
          ),
        ),

        const SizedBox(height: 8),

        ...bills.map((bill) => _billTableRow(bill)),
      ],
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    color: Colors.white54,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  // ===============================================================
  // BILL TABLE ROW
  // ===============================================================

  Widget _billTableRow(Map<String, dynamic> bill) {
    final status = bill['status'] as String;
    final total = _calculateTotal(bill);
    final statusColor = _statusColor(status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showBillDetails(context, bill);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  bill['guest'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  bill['room'],
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),

              Expanded(
                flex: 2,
                child: Text(
                  bill['billId'],
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),

              Expanded(
                child: Text(
                  _money(total),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _statusBadge(status, statusColor),
                ),
              ),

              SizedBox(
                width: 50,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white30,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // MOBILE BILL LIST
  // ===============================================================

  Widget _mobileBillList() {
    return Column(
      children: bills.map((bill) {
        final status = bill['status'] as String;
        final statusColor = _statusColor(status);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                _showBillDetails(context, bill);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: mintAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.receipt_long_outlined,
                        color: mintAccent,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bill['guest'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Room ${bill['room']} • ${bill['billId']}',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _money(_calculateTotal(bill)),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 5),

                        _statusBadge(status, statusColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ===============================================================
  // STAT CARD
  // ===============================================================

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardGlass,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  label,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // BILL DETAILS POPUP
  // ===============================================================

  void _showBillDetails(BuildContext context, Map<String, dynamic> bill) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (context) {
        final roomCharge = bill['roomCharge'] as double;

        final extraBed = bill['extraBed'] as double;

        final otherCharges = bill['otherCharges'] as double;

        final discount = bill['discount'] as double;

        final tax = bill['tax'] as double;

        final services = List<Map<String, dynamic>>.from(bill['services']);

        final serviceTotal = services.fold<double>(
          0,
          (sum, service) => sum + (service['amount'] as double),
        );

        final subtotal = roomCharge + extraBed + serviceTotal + otherCharges;

        final total = subtotal - discount + tax;

        final status = bill['status'] as String;

        return Dialog(
          backgroundColor: darkBg2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(color: Colors.white.withOpacity(0.08)),
          ),
          child: Container(
            width: 560,
            constraints: const BoxConstraints(maxHeight: 700),
            padding: const EdgeInsets.all(28),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // HEADER
                  // =================================================
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: mintAccent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.receipt_long_outlined,
                          color: mintAccent,
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bill Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              bill['billId'],
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      _statusBadge(status, _statusColor(status)),
                    ],
                  ),

                  const SizedBox(height: 26),

                  // =================================================
                  // GUEST INFORMATION
                  // =================================================
                  _sectionTitle('Guest Information'),

                  const SizedBox(height: 12),

                  _infoRow('Guest', bill['guest']),

                  _infoRow('Room', bill['room']),

                  _infoRow('Booking ID', bill['bookingId']),

                  _infoRow('Date', bill['date']),

                  const SizedBox(height: 20),

                  // =================================================
                  // CHARGES
                  // =================================================
                  _sectionTitle('Charges'),

                  const SizedBox(height: 12),

                  _chargeRow('Room Charge', roomCharge),

                  if (extraBed > 0) _chargeRow('Extra Bed', extraBed),

                  ...services.map(
                    (service) => _chargeRow(service['name'], service['amount']),
                  ),

                  if (otherCharges > 0)
                    _chargeRow('Other Charges', otherCharges),

                  const SizedBox(height: 10),

                  Divider(color: Colors.white.withOpacity(0.1)),

                  const SizedBox(height: 8),

                  _chargeRow('Subtotal', subtotal, bold: true),

                  if (discount > 0)
                    _chargeRow(
                      'Discount',
                      -discount,
                      valueColor: Colors.greenAccent,
                    ),

                  _chargeRow('Tax', tax),

                  const SizedBox(height: 12),

                  // =================================================
                  // TOTAL
                  // =================================================
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: mintAccent.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: mintAccent.withOpacity(0.18)),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'TOTAL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Text(
                          _money(total),
                          style: const TextStyle(
                            color: mintAccent,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =================================================
                  // BUTTONS
                  // =================================================
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close_rounded, size: 18),
                          label: const Text('Close'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white70,
                            side: const BorderSide(color: Colors.white24),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);

                            _showGeneratedBill(context, bill, total);
                          },
                          icon: const Icon(
                            Icons.picture_as_pdf_outlined,
                            size: 18,
                          ),
                          label: const Text('Generate Bill'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mintAccent,
                            foregroundColor: darkBg2,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===============================================================
  // GENERATED BILL MESSAGE
  // ===============================================================

  void _showGeneratedBill(
    BuildContext context,
    Map<String, dynamic> bill,
    double total,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkBg2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, color: mintAccent),
              SizedBox(width: 10),
              Text('Bill Generated', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Text(
            'Bill ${bill['billId']} has been generated successfully.\n\nTotal: ${_money(total)}',
            style: const TextStyle(color: Colors.white70, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Done', style: TextStyle(color: mintAccent)),
            ),
          ],
        );
      },
    );
  }

  // ===============================================================
  // SECTION TITLE
  // ===============================================================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ===============================================================
  // INFO ROW
  // ===============================================================

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // CHARGE ROW
  // ===============================================================

  Widget _chargeRow(
    String label,
    double amount, {
    bool bold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Text(
            _money(amount),
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 12,
              fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // STATUS BADGE
  // ===============================================================

  Widget _statusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ===============================================================
  // STATUS COLOR
  // ===============================================================

  Color _statusColor(String status) {
    switch (status) {
      case 'Paid':
        return Colors.greenAccent;

      case 'Pending':
        return Colors.amber;

      default:
        return mintAccent;
    }
  }

  // ===============================================================
  // CALCULATE TOTAL
  // ===============================================================

  double _calculateTotal(Map<String, dynamic> bill) {
    final roomCharge = bill['roomCharge'] as double;

    final extraBed = bill['extraBed'] as double;

    final otherCharges = bill['otherCharges'] as double;

    final discount = bill['discount'] as double;

    final tax = bill['tax'] as double;

    final services = List<Map<String, dynamic>>.from(bill['services']);

    final serviceTotal = services.fold<double>(
      0,
      (sum, service) => sum + (service['amount'] as double),
    );

    final subtotal = roomCharge + extraBed + serviceTotal + otherCharges;

    return subtotal - discount + tax;
  }

  // ===============================================================
  // MONEY FORMAT
  // ===============================================================

  String _money(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }
}
