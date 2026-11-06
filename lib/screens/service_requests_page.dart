import 'dart:async';

import 'package:flutter/material.dart';

import '../models/service_request.dart';
import '../models/service_request_store.dart';
import '../widgets/app_shell.dart';

class ServiceRequestsPage extends StatefulWidget {
  const ServiceRequestsPage({super.key});

  @override
  State<ServiceRequestsPage> createState() => _ServiceRequestsPageState();
}

class _ServiceRequestsPageState extends State<ServiceRequestsPage> {
  static const darkBg = Color(0xFF13241B);
  static const darkBg2 = Color(0xFF0D1A13);
  static const mintAccent = Color(0xFFB7F5C8);
  static const cardGlass = Color(0x1AFFFFFF);

  Timer? _timer;

  String selectedFilter = 'All';

  final List<String> filters = [
    'All',
    'Pending',
    'Assigned',
    'In Progress',
    'Completed',
    'Overdue',
  ];

  final List<Map<String, String>> servicePersons = [
    {'id': 'SP001', 'name': 'Karthik'},
    {'id': 'SP002', 'name': 'Rahul'},
    {'id': 'SP003', 'name': 'Priya'},
  ];

  final ServiceRequestStore _store = ServiceRequestStore.instance;

  @override
  void initState() {
    super.initState();

    // Refresh the page every second so the timer visibly moves.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        _updateOverdueRequests();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ------------------------------------------------------------
  // OVERDUE CHECK
  // ------------------------------------------------------------

  void _updateOverdueRequests() {
    final now = DateTime.now();

    for (final request in _store.requests) {
      // Timer only exists after ADMIN assigns the request.
      if (request.assignedAt == null) {
        continue;
      }

      // Completed requests should remain completed.
      if (request.status == 'Completed') {
        continue;
      }

      // Timer keeps running from assignedAt.
      if (request.status == 'Assigned' || request.status == 'In Progress') {
        final elapsed = now.difference(request.assignedAt!).inSeconds;

        if (elapsed >= 10 * 60) {
          request.status = 'Overdue';
        }
      }
    }
  }

  // ------------------------------------------------------------
  // FILTERED REQUESTS
  // ------------------------------------------------------------

  List<ServiceRequest> get filteredRequests {
    final requests = _store.requests;

    if (selectedFilter == 'All') {
      return requests;
    }

    return requests
        .where((request) => request.status == selectedFilter)
        .toList();
  }

  int get totalRequests => _store.requests.length;

  int get pendingRequests =>
      _store.requests.where((request) => request.status == 'Pending').length;

  int get inProgressRequests => _store.requests
      .where((request) => request.status == 'In Progress')
      .length;

  int get overdueRequests =>
      _store.requests.where((request) => request.status == 'Overdue').length;

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentSection: AppSection.serviceRequests,
      child: Container(
        color: darkBg,
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 22, 28, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPageHeader(),
                      const SizedBox(height: 24),
                      _buildStats(),
                      const SizedBox(height: 22),
                      _buildFilters(),
                      const SizedBox(height: 18),

                      if (filteredRequests.isEmpty) _buildEmptyState(),

                      ...filteredRequests.map(
                        (request) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildRequestCard(request),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // TOP BAR
  // ------------------------------------------------------------

  Widget _buildTopBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: darkBg2,
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          const Spacer(),

          SizedBox(
            width: 300,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search_rounded, size: 18, color: Colors.white38),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Search requests, rooms, or guests...',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 18),

          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white70,
                size: 23,
              ),

              if (overdueRequests > 0)
                Positioned(
                  right: -2,
                  top: -1,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 20),

          const Icon(Icons.wb_sunny_outlined, color: Colors.white60, size: 22),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildPageHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: mintAccent.withOpacity(0.10),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: mintAccent.withOpacity(0.12)),
          ),
          child: const Icon(
            Icons.room_service_outlined,
            color: mintAccent,
            size: 27,
          ),
        ),

        const SizedBox(width: 16),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service Requests',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Manage and monitor guest service operations.',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // STATS
  // ------------------------------------------------------------

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.assignment_outlined,
            value: totalRequests.toString().padLeft(2, '0'),
            title: 'Total Requests',
            accent: mintAccent,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: _statCard(
            icon: Icons.schedule_rounded,
            value: pendingRequests.toString().padLeft(2, '0'),
            title: 'Pending',
            accent: Colors.amberAccent,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: _statCard(
            icon: Icons.play_arrow_rounded,
            value: inProgressRequests.toString().padLeft(2, '0'),
            title: 'In Progress',
            accent: Colors.lightBlueAccent,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: _statCard(
            icon: Icons.warning_amber_rounded,
            value: overdueRequests.toString().padLeft(2, '0'),
            title: 'Overdue',
            accent: Colors.redAccent,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String title,
    required Color accent,
  }) {
    return Container(
      height: 102,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkBg2,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: accent, size: 23),
          ),

          const SizedBox(width: 14),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // FILTERS
  // ------------------------------------------------------------

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((filter) {
                final active = selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: active ? mintAccent : Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: active ? mintAccent : Colors.white10,
                        ),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: active ? darkBg : Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(width: 16),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white10),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sort by: Latest',
                style: TextStyle(color: Colors.white60, fontSize: 11),
              ),
              SizedBox(width: 7),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white54,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // EMPTY STATE
  // ------------------------------------------------------------

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: darkBg2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: const Column(
        children: [
          Icon(Icons.room_service_outlined, color: Colors.white24, size: 44),
          SizedBox(height: 14),
          Text(
            'No service requests',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Guest service requests will appear here.',
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // REQUEST CARD
  // ------------------------------------------------------------

  Widget _buildRequestCard(ServiceRequest request) {
    final elapsed = _elapsedDuration(request);

    final elapsedSeconds = elapsed.inSeconds.clamp(0, 999999);

    const slaMinutes = 10;

    final slaSeconds = slaMinutes * 60;

    final progress = (elapsedSeconds / slaSeconds).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: darkBg2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: request.status == 'Overdue'
              ? Colors.redAccent.withOpacity(0.35)
              : Colors.white10,
        ),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 4, child: _buildRequestInfo(request)),

                Container(
                  width: 1,
                  color: Colors.white10,
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                ),

                Expanded(
                  flex: 5,
                  child: _buildProgressSection(request, elapsed, progress),
                ),

                Container(
                  width: 1,
                  color: Colors.white10,
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                ),

                Expanded(flex: 2, child: _buildRequestActions(request)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // REQUEST INFO
  // ------------------------------------------------------------

  Widget _buildRequestInfo(ServiceRequest request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: mintAccent.withOpacity(0.09),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                _serviceIcon(request.serviceType),
                color: mintAccent,
                size: 24,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      request.serviceType,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(width: 9),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: mintAccent.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Room ${request.roomNumber}',
                      style: const TextStyle(
                        color: mintAccent,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 17),

        Text(
          '"${request.remark}"',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            height: 1.45,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'Guest Remark',
          style: TextStyle(color: Colors.white38, fontSize: 10),
        ),

        const Spacer(),

        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              color: Colors.white38,
              size: 15,
            ),
            const SizedBox(width: 6),
            Text(
              'Requested ${_formatTime(request.createdAt)}',
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),

            const SizedBox(width: 18),

            const Icon(
              Icons.person_outline_rounded,
              color: Colors.white38,
              size: 15,
            ),

            const SizedBox(width: 6),

            Flexible(
              child: Text(
                request.assignedStaffName == null
                    ? 'Not assigned'
                    : 'Assigned to ${request.assignedStaffName}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white54, fontSize: 10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // PROGRESS
  // ------------------------------------------------------------

  Widget _buildProgressSection(
    ServiceRequest request,
    Duration elapsed,
    double progress,
  ) {
    final stages = [
      'Requested',
      'Assigned',
      'Accepted',
      'In Progress',
      'Completed',
    ];

    final currentIndex = _currentStageIndex(request.status);

    return Column(
      children: [
        const SizedBox(height: 4),

        Row(
          children: List.generate(stages.length, (index) {
            final completed = index < currentIndex;

            final current = index == currentIndex;

            final isOverdue = request.status == 'Overdue';

            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: completed || current
                          ? (isOverdue ? Colors.redAccent : mintAccent)
                          : darkBg,
                      border: Border.all(
                        color: completed || current
                            ? (isOverdue ? Colors.redAccent : mintAccent)
                            : Colors.white24,
                        width: 2,
                      ),
                    ),
                    child: completed
                        ? Icon(Icons.check, size: 11, color: darkBg)
                        : null,
                  ),

                  if (index != stages.length - 1)
                    Expanded(
                      child: Container(
                        height: 1,
                        color: index < currentIndex
                            ? mintAccent
                            : Colors.white12,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),

        const SizedBox(height: 6),

        Row(
          children: stages.map((stage) {
            final index = stages.indexOf(stage);

            return Expanded(
              child: Text(
                stage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: index <= currentIndex
                      ? Colors.white70
                      : Colors.white30,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 17),

        _buildTimerBox(request, elapsed, progress),
      ],
    );
  }

  // ------------------------------------------------------------
  // TIMER
  // ------------------------------------------------------------

  Widget _buildTimerBox(
    ServiceRequest request,
    Duration elapsed,
    double progress,
  ) {
    final isOverdue = request.status == 'Overdue';

    const slaMinutes = 10;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: isOverdue
            ? Colors.redAccent.withOpacity(0.05)
            : Colors.white.withOpacity(0.025),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOverdue
              ? Colors.redAccent.withOpacity(0.22)
              : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isOverdue
                  ? Colors.redAccent.withOpacity(0.10)
                  : mintAccent.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isOverdue ? Icons.timer_off_outlined : Icons.timer_outlined,
              color: isOverdue ? Colors.redAccent : mintAccent,
              size: 21,
            ),
          ),

          const SizedBox(width: 11),

          SizedBox(
            width: 105,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDuration(elapsed),
                  style: TextStyle(
                    color: isOverdue ? Colors.redAccent : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  isOverdue
                      ? 'Overdue by ${_formatDuration(elapsed - const Duration(minutes: slaMinutes))}'
                      : 'Time elapsed',
                  style: TextStyle(
                    color: isOverdue ? Colors.redAccent : Colors.white38,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SLA: $slaMinutes min',
                      style: TextStyle(
                        color: isOverdue ? Colors.redAccent : Colors.white54,
                        fontSize: 10,
                      ),
                    ),

                    if (!isOverdue && request.status != 'Pending')
                      Text(
                        'Remaining ${_remainingSla(request)}',
                        style: const TextStyle(color: mintAccent, fontSize: 10),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    value: progress,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOverdue ? Colors.redAccent : mintAccent,
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

  // ------------------------------------------------------------
  // RIGHT ACTIONS
  // ------------------------------------------------------------

  Widget _buildRequestActions(ServiceRequest request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: _statusChip(request.status),
        ),

        const SizedBox(height: 14),

        if (request.assignedStaffName != null) ...[
          Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: mintAccent.withOpacity(0.13),
                child: Text(
                  request.assignedStaffName![0],
                  style: const TextStyle(
                    color: mintAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.assignedStaffName!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Service Person',
                      style: TextStyle(color: Colors.white38, fontSize: 9),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
        ],

        if (request.status == 'Pending') _buildAssignmentDropdown(request),

        const Spacer(),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _showDetails(request);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white12),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ),

        if (request.status == 'In Progress') ...[
          const SizedBox(height: 8),

          ElevatedButton.icon(
            onPressed: () {
              _completeRequest(request);
            },
            icon: const Icon(Icons.check_rounded, size: 15),
            label: const Text(
              'Complete',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: mintAccent,
              foregroundColor: darkBg,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],

        if (request.status == 'Overdue') ...[
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.05),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: Colors.redAccent.withOpacity(0.20)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 15,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Automatic alert triggered',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ------------------------------------------------------------
  // ASSIGNMENT DROPDOWN
  // ------------------------------------------------------------

  Widget _buildAssignmentDropdown(ServiceRequest request) {
    return Container(
      height: 39,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: request.assignedStaffId,
          dropdownColor: darkBg2,
          isExpanded: true,
          hint: const Text(
            'Assign Service Person',
            style: TextStyle(color: Colors.white54, fontSize: 10),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white38,
            size: 17,
          ),
          style: const TextStyle(color: Colors.white70, fontSize: 10),
          items: servicePersons.map((person) {
            return DropdownMenuItem<String>(
              value: person['id'],
              child: Text(person['name']!),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) return;

            final person = servicePersons.firstWhere(
              (item) => item['id'] == value,
            );

            setState(() {
              _store.assignStaff(
                requestId: request.id,
                staffId: person['id']!,
                staffName: person['name']!,
              );
            });
          },
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // STATUS
  // ------------------------------------------------------------

  Widget _statusChip(String status) {
    Color color;

    switch (status) {
      case 'Pending':
        color = Colors.amberAccent;
        break;

      case 'Assigned':
        color = Colors.lightBlueAccent;
        break;

      case 'In Progress':
        color = Colors.lightBlueAccent;
        break;

      case 'Completed':
        color = mintAccent;
        break;

      case 'Overdue':
        color = Colors.redAccent;
        break;

      default:
        color = Colors.white54;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
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

    if (value.contains('service')) {
      return Icons.room_service_outlined;
    }

    if (value.contains('pillow')) {
      return Icons.bed_outlined;
    }

    return Icons.room_service_outlined;
  }

  int _currentStageIndex(String status) {
    switch (status) {
      case 'Pending':
        return 0;

      case 'Assigned':
        return 1;

      case 'In Progress':
        return 3;

      case 'Completed':
        return 4;

      case 'Overdue':
        return 3;

      default:
        return 0;
    }
  }

  // IMPORTANT:
  // The timer starts from assignedAt.
  // It does NOT start from acceptedAt.
  Duration _elapsedDuration(ServiceRequest request) {
    if (request.assignedAt == null) {
      return Duration.zero;
    }

    final end = request.completedAt ?? DateTime.now();

    return end.difference(request.assignedAt!);
  }

  String _remainingSla(ServiceRequest request) {
    const slaMinutes = 10;

    final elapsed = _elapsedDuration(request);

    final remaining = const Duration(minutes: slaMinutes) - elapsed;

    if (remaining.isNegative) {
      return '00:00';
    }

    return _formatDuration(remaining);
  }

  String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds.clamp(0, 999999);

    final minutes = totalSeconds ~/ 60;

    final seconds = totalSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour == 0 ? 12 : time.hour % 12;

    final minute = time.minute.toString().padLeft(2, '0');

    final suffix = time.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $suffix';
  }

  // ------------------------------------------------------------
  // ACTIONS
  // ------------------------------------------------------------

  void _completeRequest(ServiceRequest request) {
    setState(() {
      _store.completeRequest(request.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Service request marked as completed.')),
    );
  }

  void _showDetails(ServiceRequest request) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkBg2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Request Details',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Request ID', request.id),
              _detailRow('Guest', request.guestName),
              _detailRow('Service', request.serviceType),
              _detailRow('Room', request.roomNumber),
              _detailRow('Guest Remark', request.remark),
              _detailRow('Status', request.status),
              _detailRow(
                'Assigned To',
                request.assignedStaffName ?? 'Not assigned',
              ),
              _detailRow('SLA', '10 minutes'),
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
