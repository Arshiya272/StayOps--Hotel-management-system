import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/app_shell.dart';
import '../models/room_data.dart';
import '../models/service_request.dart';
import '../models/service_request_store.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const darkBg2 = Color(0xFF0D1A13);
  static const mintAccent = Color(0xFFB7F5C8);
  static const cardGlass = Color(0x1AFFFFFF);

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Rebuild every second so overdue request counts
    // stay live while the 10-minute SLA is running.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentSection: AppSection.dashboard,
      child: AnimatedBuilder(
        animation: ServiceRequestStore.instance,
        builder: (context, _) {
          return ValueListenableBuilder<List<Room>>(
            valueListenable: RoomData.rooms,
            builder: (context, rooms, _) {
              // ==========================================================
              // ROOM DATA
              // ==========================================================

              final totalRooms = rooms.length;

              final availableRooms = rooms
                  .where((room) => room.status == RoomStatus.available)
                  .length;

              final occupiedRooms = rooms
                  .where((room) => room.status == RoomStatus.occupied)
                  .length;

              final maintenanceRooms = rooms
                  .where((room) => room.status == RoomStatus.maintenance)
                  .length;

              final occupancyPct = totalRooms == 0
                  ? 0.0
                  : occupiedRooms / totalRooms;

              // ==========================================================
              // SERVICE REQUEST DATA
              // ==========================================================

              final requestStore = ServiceRequestStore.instance;

              final requests = requestStore.requests;

              final totalRequests = requests.length;

              final pendingRequests = requests
                  .where((request) => request.status == 'Pending')
                  .length;

              final inProgressRequests = requests
                  .where((request) => request.status == 'In Progress')
                  .length;

              final overdueRequests = requests
                  .where((request) => requestStore.isOverdue(request))
                  .length;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ======================================================
                    // HEADER
                    // ======================================================
                    const Text(
                      'Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Overview of your hotel operations',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),

                    const SizedBox(height: 28),

                    // ======================================================
                    // ROOM STATISTICS
                    // ======================================================
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 700;

                        final cards = [
                          _statCard(
                            'Total Rooms',
                            '$totalRooms',
                            Icons.bed_rounded,
                            mintAccent,
                          ),
                          _statCard(
                            'Available',
                            '$availableRooms',
                            Icons.check_circle_outline_rounded,
                            Colors.greenAccent,
                          ),
                          _statCard(
                            'Occupied',
                            '$occupiedRooms',
                            Icons.person_outline_rounded,
                            Colors.amber,
                          ),
                          _statCard(
                            'Maintenance',
                            '$maintenanceRooms',
                            Icons.build_outlined,
                            Colors.redAccent,
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

                    const SizedBox(height: 28),

                    // ======================================================
                    // SERVICE REQUESTS
                    // ======================================================
                    const Text(
                      'Service Requests',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 14),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 700;

                        final serviceCards = [
                          _statCard(
                            'Total Requests',
                            '$totalRequests',
                            Icons.assignment_outlined,
                            mintAccent,
                          ),
                          _statCard(
                            'Pending',
                            '$pendingRequests',
                            Icons.access_time_rounded,
                            Colors.amber,
                          ),
                          _statCard(
                            'In Progress',
                            '$inProgressRequests',
                            Icons.play_arrow_rounded,
                            Colors.lightBlueAccent,
                          ),
                          _statCard(
                            'Overdue',
                            '$overdueRequests',
                            Icons.warning_amber_rounded,
                            Colors.redAccent,
                          ),
                        ];

                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: serviceCards.map((card) {
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

                    const SizedBox(height: 28),

                    // ======================================================
                    // LOWER DASHBOARD
                    // ======================================================
                    if (totalRooms == 0)
                      _emptyState(context)
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 800;

                          final occupancy = _occupancyCard(
                            occupancyPct,
                            availableRooms,
                            occupiedRooms,
                            maintenanceRooms,
                          );

                          final activity = _activityCard();

                          if (isWide) {
                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(flex: 4, child: occupancy),
                                  const SizedBox(width: 16),
                                  Expanded(flex: 6, child: activity),
                                ],
                              ),
                            );
                          }

                          return Column(
                            children: [
                              occupancy,
                              const SizedBox(height: 16),
                              activity,
                            ],
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ================================================================
  // EMPTY STATE
  // ================================================================

  Widget _emptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: cardGlass,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: mintAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.bed_rounded, color: mintAccent, size: 28),
          ),

          const SizedBox(height: 18),

          const Text(
            'No rooms yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Add your first room to start tracking occupancy and activity.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/rooms');
            },
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add Your First Room'),
            style: ElevatedButton.styleFrom(
              backgroundColor: mintAccent,
              foregroundColor: darkBg2,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // STAT CARD
  // ================================================================

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
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

  // ================================================================
  // OCCUPANCY
  // ================================================================

  Widget _occupancyCard(
    double occupancyPct,
    int available,
    int occupied,
    int maintenance,
  ) {
    final pctLabel = '${(occupancyPct * 100).round()}%';

    return Container(
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
            'Occupancy Overview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: occupancyPct,
                      strokeWidth: 14,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor: const AlwaysStoppedAnimation(mintAccent),
                    ),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        pctLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Occupied',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          _legendRow(Colors.greenAccent, 'Available', '$available'),

          _legendRow(Colors.amber, 'Occupied', '$occupied'),

          _legendRow(Colors.redAccent, 'Maintenance', '$maintenance'),
        ],
      ),
    );
  }

  Widget _legendRow(Color color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),

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
    );
  }

  // ================================================================
  // ACTIVITY
  // ================================================================

  Widget _activityCard() {
    return ValueListenableBuilder<List<ActivityEntry>>(
      valueListenable: RoomData.activity,
      builder: (context, entries, _) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardGlass,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  if (entries.length > 5)
                    const Text(
                      'View all',
                      style: TextStyle(color: mintAccent, fontSize: 12),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              if (entries.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No activity yet. Actions like adding rooms or updating status will show up here.',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                )
              else
                ...entries.take(5).map((entry) {
                  final (icon, color) = _iconFor(entry.type);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon, color: color, size: 16),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                entry.subtitle,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Text(
                          _timeAgo(entry.time),
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  // ================================================================
  // ACTIVITY ICON
  // ================================================================

  (IconData, Color) _iconFor(ActivityType type) {
    switch (type) {
      case ActivityType.added:
        return (Icons.add_circle_outline_rounded, Colors.amber);

      case ActivityType.statusUpdated:
        return (Icons.check_circle_outline_rounded, Colors.greenAccent);

      case ActivityType.removed:
        return (Icons.remove_circle_outline_rounded, Colors.redAccent);
    }
  }

  // ================================================================
  // TIME AGO
  // ================================================================

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);

    if (diff.inSeconds < 60) {
      return 'just now';
    }

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    }

    if (diff.inHours < 24) {
      return '${diff.inHours} hr ago';
    }

    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  }
}
