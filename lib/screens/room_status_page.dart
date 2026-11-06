import 'package:flutter/material.dart';

import '../models/room_data.dart';
import '../widgets/app_shell.dart';

class RoomStatusPage extends StatefulWidget {
  const RoomStatusPage({super.key});

  @override
  State<RoomStatusPage> createState() => _RoomStatusPageState();
}

class _RoomStatusPageState extends State<RoomStatusPage> {
  String searchQuery = '';
  RoomStatus? statusFilter;

  static const darkBg = Color(0xFF13241B);
  static const darkBg2 = Color(0xFF0D1A13);
  static const mintAccent = Color(0xFFB7F5C8);
  static const cardGlass = Color(0x1AFFFFFF);

  List<Room> _filteredRooms(List<Room> rooms) {
    return rooms.where((room) {
      final query = searchQuery.trim().toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          room.roomNumber.toLowerCase().contains(query) ||
          room.floor.toLowerCase().contains(query) ||
          room.roomCategory.label.toLowerCase().contains(query);

      final matchesStatus = statusFilter == null || room.status == statusFilter;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentSection: AppSection.roomStatus,
      child: ValueListenableBuilder<List<Room>>(
        valueListenable: RoomData.rooms,
        builder: (context, rooms, _) {
          final filteredRooms = _filteredRooms(rooms);

          final total = rooms.length;
          final available = rooms
              .where((r) => r.status == RoomStatus.available)
              .length;
          final occupied = rooms
              .where((r) => r.status == RoomStatus.occupied)
              .length;
          final reserved = rooms
              .where((r) => r.status == RoomStatus.reserved)
              .length;
          final cleaning = rooms
              .where((r) => r.status == RoomStatus.cleaning)
              .length;
          final maintenance = rooms
              .where((r) => r.status == RoomStatus.maintenance)
              .length;

          return Container(
            color: darkBg,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Room Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Monitor and update the current status of every room.',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),

                  const SizedBox(height: 28),

                  // ----------------------------------------------------------
                  // STATUS SUMMARY
                  // ----------------------------------------------------------
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 900;

                      final cards = [
                        _statusSummaryCard(
                          'Total Rooms',
                          total,
                          Icons.bed_rounded,
                          mintAccent,
                        ),
                        _statusSummaryCard(
                          'Available',
                          available,
                          Icons.check_circle_outline_rounded,
                          Colors.greenAccent,
                        ),
                        _statusSummaryCard(
                          'Occupied',
                          occupied,
                          Icons.person_outline_rounded,
                          Colors.amber,
                        ),
                        _statusSummaryCard(
                          'Reserved',
                          reserved,
                          Icons.bookmark_outline_rounded,
                          Colors.lightBlueAccent,
                        ),
                        _statusSummaryCard(
                          'Cleaning',
                          cleaning,
                          Icons.cleaning_services_outlined,
                          Colors.orangeAccent,
                        ),
                        _statusSummaryCard(
                          'Maintenance',
                          maintenance,
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
                                ? (constraints.maxWidth - 32) / 3
                                : constraints.maxWidth,
                            child: card,
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // ----------------------------------------------------------
                  // SEARCH + FILTER
                  // ----------------------------------------------------------
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 700;

                      if (isWide) {
                        return Row(
                          children: [
                            Expanded(child: _searchField()),
                            const SizedBox(width: 12),
                            SizedBox(width: 220, child: _statusDropdown()),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          _searchField(),
                          const SizedBox(height: 12),
                          _statusDropdown(),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // ----------------------------------------------------------
                  // ROOMS
                  // ----------------------------------------------------------
                  if (filteredRooms.isEmpty)
                    _emptyState(rooms.isEmpty)
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth > 1100
                            ? 3
                            : constraints.maxWidth > 700
                            ? 2
                            : 1;

                        const spacing = 16.0;

                        final width =
                            (constraints.maxWidth - spacing * (columns - 1)) /
                            columns;

                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: filteredRooms.map((room) {
                            return SizedBox(
                              width: width,
                              child: _roomStatusCard(room),
                            );
                          }).toList(),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --------------------------------------------------------------------------
  // SUMMARY CARD
  // --------------------------------------------------------------------------

  Widget _statusSummaryCard(
    String title,
    int value,
    IconData icon,
    Color color,
  ) {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$value',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // SEARCH
  // --------------------------------------------------------------------------

  Widget _searchField() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search rooms...',
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: const Icon(Icons.search_rounded, color: Colors.white38),
        filled: true,
        fillColor: cardGlass,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: mintAccent),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // STATUS FILTER
  // --------------------------------------------------------------------------

  Widget _statusDropdown() {
    return DropdownButtonFormField<RoomStatus?>(
      initialValue: statusFilter,
      dropdownColor: darkBg2,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Filter by Status',
        labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: cardGlass,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
      ),
      items: [
        const DropdownMenuItem<RoomStatus?>(
          value: null,
          child: Text('All Status', style: TextStyle(color: Colors.white)),
        ),
        ...RoomStatus.values.map(
          (status) => DropdownMenuItem<RoomStatus?>(
            value: status,
            child: Text(
              status.label,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          statusFilter = value;
        });
      },
    );
  }

  // --------------------------------------------------------------------------
  // ROOM STATUS CARD
  // --------------------------------------------------------------------------

  Widget _roomStatusCard(Room room) {
    final color = _statusColor(room.status);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardGlass,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: mintAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.bed_rounded,
                  color: mintAccent,
                  size: 23,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room ${room.roomNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${room.roomCategory.label} • Floor ${room.floor}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.22)),
            ),
            child: Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
                const SizedBox(width: 9),
                Text(
                  room.status.label,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _changeStatus(room);
                  },
                  icon: const Icon(Icons.swap_vert_rounded, size: 17),
                  label: const Text('Change Status'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: mintAccent,
                    side: const BorderSide(color: Colors.white12),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // CHANGE STATUS
  // --------------------------------------------------------------------------

  Future<void> _changeStatus(Room room) async {
    final selected = await showDialog<RoomStatus>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: darkBg2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            'Room ${room.roomNumber}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: RoomStatus.values.map((status) {
              final isSelected = status == room.status;
              final color = _statusColor(status);

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: color,
                ),
                title: Text(
                  status.label,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(dialogContext, status);
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (!mounted || selected == null) return;
    if (selected == room.status) return;

    RoomData.updateStatus(room.id, selected);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Room ${room.roomNumber} marked as ${selected.label}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  // --------------------------------------------------------------------------
  // EMPTY STATE
  // --------------------------------------------------------------------------

  Widget _emptyState(bool noRooms) {
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
          Text(
            noRooms ? 'No rooms yet' : 'No matching rooms',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            noRooms
                ? 'Add rooms from Room Management to see their status here.'
                : 'Try changing your search or status filter.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // STATUS COLORS
  // --------------------------------------------------------------------------

  Color _statusColor(RoomStatus status) {
    switch (status) {
      case RoomStatus.available:
        return Colors.greenAccent;
      case RoomStatus.occupied:
        return Colors.amber;
      case RoomStatus.reserved:
        return Colors.lightBlueAccent;
      case RoomStatus.cleaning:
        return Colors.orangeAccent;
      case RoomStatus.maintenance:
        return Colors.redAccent;
    }
  }
}
