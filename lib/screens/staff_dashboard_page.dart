import 'dart:async';

import 'package:flutter/material.dart';

class StaffDashboardPage extends StatefulWidget {
  const StaffDashboardPage({super.key});

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  static const Color darkBg = Color(0xFF13241B);
  static const Color darkBg2 = Color(0xFF0D1A13);
  static const Color mintAccent = Color(0xFFB7F5C8);

  Timer? _timer;

  bool requestAccepted = false;
  bool requestCompleted = false;

  int elapsedSeconds = 0;

  final List<Map<String, String>> completedRequests = [];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _acceptRequest() {
    setState(() {
      requestAccepted = true;
      elapsedSeconds = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        elapsedSeconds++;
      });
    });
  }

  void _completeRequest() {
    _timer?.cancel();

    setState(() {
      requestCompleted = true;
      completedRequests.insert(0, {
        'service': 'Housekeeping',
        'room': 'Room 204',
        'time': _formatTime(elapsedSeconds),
      });
    });
  }

  void _logout() {
    _timer?.cancel();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
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
          child: Row(
            children: [
              _buildSidebar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 30),
                          _buildStats(),
                          const SizedBox(height: 30),
                          _buildCurrentRequest(),
                          const SizedBox(height: 30),
                          _buildCompletedRequests(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 240,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.025),
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: mintAccent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.room_service_rounded,
                    color: mintAccent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'StayOps',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 45),
            _sidebarItem(
              icon: Icons.dashboard_outlined,
              title: 'Dashboard',
              selected: true,
            ),
            _sidebarItem(icon: Icons.assignment_outlined, title: 'My Requests'),
            _sidebarItem(icon: Icons.check_circle_outline, title: 'Completed'),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.035),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: mintAccent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      color: mintAccent,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Staff Member',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded, size: 17),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white.withValues(alpha: 0.65),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sidebarItem({
    required IconData icon,
    required String title,
    bool selected = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: selected
            ? mintAccent.withValues(alpha: 0.09)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: selected ? mintAccent : Colors.white.withValues(alpha: 0.45),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.55),
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good evening, Staff Member 👋',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Staff Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            color: mintAccent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: mintAccent.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: mintAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Available',
                style: TextStyle(
                  color: mintAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.pending_actions_rounded,
            title: 'Pending',
            value: requestCompleted ? '0' : '1',
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: _statCard(
            icon: Icons.timelapse_rounded,
            title: 'In Progress',
            value: requestAccepted && !requestCompleted ? '1' : '0',
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: _statCard(
            icon: Icons.check_circle_outline_rounded,
            title: 'Completed',
            value: '${completedRequests.length}',
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: mintAccent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: mintAccent, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentRequest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Current Request',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.035),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: requestAccepted
                  ? mintAccent.withValues(alpha: 0.20)
                  : Colors.white.withValues(alpha: 0.07),
            ),
          ),
          child: requestCompleted
              ? _buildCompletedState()
              : _buildActiveRequest(),
        ),
      ],
    );
  }

  Widget _buildActiveRequest() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: mintAccent.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.cleaning_services_outlined,
                color: mintAccent,
                size: 28,
              ),
            ),
            const SizedBox(width: 17),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Housekeeping',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Room 204',
                    style: TextStyle(
                      color: mintAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (requestAccepted) _timerBadge(),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.notes_rounded,
                color: Colors.white.withValues(alpha: 0.4),
                size: 19,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  'Guest requested extra towels for the room.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (!requestAccepted)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _acceptRequest,
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              label: const Text('Accept Request'),
              style: ElevatedButton.styleFrom(
                backgroundColor: mintAccent,
                foregroundColor: darkBg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _completeRequest,
              icon: const Icon(Icons.check_rounded, size: 20),
              label: const Text('Complete Request'),
              style: ElevatedButton.styleFrom(
                backgroundColor: mintAccent,
                foregroundColor: darkBg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _timerBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: mintAccent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: mintAccent, size: 17),
          const SizedBox(width: 7),
          Text(
            _formatTime(elapsedSeconds),
            style: const TextStyle(
              color: mintAccent,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedState() {
    return Column(
      children: [
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: mintAccent.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: mintAccent, size: 32),
        ),
        const SizedBox(height: 15),
        const Text(
          'Request Completed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'Housekeeping • Room 204',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Completed in ${_formatTime(elapsedSeconds)}',
          style: const TextStyle(
            color: mintAccent,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedRequests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Completed Requests',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        if (completedRequests.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.025),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Center(
              child: Text(
                'No completed requests yet.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.35),
                  fontSize: 13,
                ),
              ),
            ),
          )
        else
          ...completedRequests.map(
            (request) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: mintAccent,
                    size: 22,
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request['service']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          request['room']!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.40),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    request['time']!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
