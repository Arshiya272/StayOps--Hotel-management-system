import 'package:flutter/material.dart';

import '../models/room_data.dart';
import '../widgets/app_shell.dart';

// -----------------------------------------------------------------------------
// ORIGINAL STAYOPS COLORS
// -----------------------------------------------------------------------------

const Color darkBg = Color(0xFF13241B);
const Color darkBg2 = Color(0xFF0D1A13);
const Color mintAccent = Color(0xFFB7F5C8);
const Color cardGlass = Color(0x1AFFFFFF);

// -----------------------------------------------------------------------------
// ROOMS PAGE
// -----------------------------------------------------------------------------

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  String searchQuery = '';
  RoomStatus? statusFilter;
  RoomCategory? categoryFilter;

  // ---------------------------------------------------------------------------
  // ADD / EDIT ROOM
  // ---------------------------------------------------------------------------

  Future<void> _showRoomDialog({Room? room}) async {
    final result = await showDialog<RoomFormResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RoomFormDialog(room: room),
    );

    if (!mounted || result == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (result.isEditing && result.roomId != null) {
        RoomData.updateRoom(
          id: result.roomId!,
          roomNumber: result.roomNumber,
          floor: result.floor,
          roomCategory: result.roomCategory,
          location: result.location,
          airConditioning: result.airConditioning,
          bathroomType: result.bathroomType,
          bedType: result.bedType,
          capacity: result.capacity,
          extraBedAvailable: result.extraBedAvailable,
          extraBedCharge: result.extraBedCharge,
          roomRate: result.roomRate,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Room updated successfully'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      } else {
        RoomData.addRoom(
          roomNumber: result.roomNumber,
          floor: result.floor,
          roomCategory: result.roomCategory,
          location: result.location,
          airConditioning: result.airConditioning,
          bathroomType: result.bathroomType,
          bedType: result.bedType,
          capacity: result.capacity,
          extraBedAvailable: result.extraBedAvailable,
          extraBedCharge: result.extraBedCharge,
          roomRate: result.roomRate,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Room added successfully'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
    });
  }

  // ---------------------------------------------------------------------------
  // STATUS DIALOG
  // ---------------------------------------------------------------------------

  Future<void> _showStatusDialog(Room room) async {
    final selected = await showDialog<RoomStatus>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: darkBg2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Update Room Status',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: RoomStatus.values.map((status) {
              final isSelected = room.status == status;

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected ? mintAccent : Colors.white38,
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
      const SnackBar(
        content: Text('Room status updated'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------

  Future<void> _confirmDelete(Room room) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: darkBg2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Delete Room?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Are you sure you want to remove Room ${room.roomNumber}?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white60),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldDelete != true) return;

    RoomData.deleteRoom(room.id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Room deleted'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FILTERING
  // ---------------------------------------------------------------------------

  List<Room> _filteredRooms(List<Room> rooms) {
    return rooms.where((room) {
      final query = searchQuery.trim().toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          room.roomNumber.toLowerCase().contains(query) ||
          room.floor.toLowerCase().contains(query) ||
          room.roomCategory.label.toLowerCase().contains(query);

      final matchesStatus = statusFilter == null || room.status == statusFilter;

      final matchesCategory =
          categoryFilter == null || room.roomCategory == categoryFilter;

      return matchesSearch && matchesStatus && matchesCategory;
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentSection: AppSection.rooms,
      child: ValueListenableBuilder<List<Room>>(
        valueListenable: RoomData.rooms,
        builder: (context, rooms, _) {
          final filteredRooms = _filteredRooms(rooms);

          return Container(
            color: darkBg,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PAGE HEADER
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rooms',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Manage your hotel rooms and availability',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showRoomDialog();
                        },
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Add Room'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mintAccent,
                          foregroundColor: darkBg2,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // FILTER BAR
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 800;

                      if (isWide) {
                        return Row(
                          children: [
                            Expanded(child: _searchField()),
                            const SizedBox(width: 12),
                            SizedBox(width: 190, child: _statusDropdown()),
                            const SizedBox(width: 12),
                            SizedBox(width: 180, child: _categoryDropdown()),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          _searchField(),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _statusDropdown()),
                              const SizedBox(width: 12),
                              Expanded(child: _categoryDropdown()),
                            ],
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // ROOM LIST
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
                              child: _roomCard(room),
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

  // ---------------------------------------------------------------------------
  // SEARCH
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // STATUS FILTER
  // ---------------------------------------------------------------------------

  Widget _statusDropdown() {
    return DropdownButtonFormField<RoomStatus?>(
      initialValue: statusFilter,
      dropdownColor: darkBg2,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Status',
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

  // ---------------------------------------------------------------------------
  // CATEGORY FILTER
  // ---------------------------------------------------------------------------

  Widget _categoryDropdown() {
    return DropdownButtonFormField<RoomCategory?>(
      initialValue: categoryFilter,
      dropdownColor: darkBg2,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Room Type',
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
        const DropdownMenuItem<RoomCategory?>(
          value: null,
          child: Text('All types', style: TextStyle(color: Colors.white)),
        ),
        ...RoomCategory.values.map(
          (category) => DropdownMenuItem<RoomCategory?>(
            value: category,
            child: Text(
              category.label,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          categoryFilter = value;
        });
      },
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY STATE
  // ---------------------------------------------------------------------------

  Widget _emptyState(bool noRoomsAtAll) {
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
            noRoomsAtAll ? 'No rooms yet' : 'No matching rooms',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            noRoomsAtAll
                ? 'Add your first room to start tracking occupancy and activity.'
                : 'Try changing your search or filters.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          if (noRoomsAtAll) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _showRoomDialog();
              },
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add Your First Room'),
              style: ElevatedButton.styleFrom(
                backgroundColor: mintAccent,
                foregroundColor: darkBg2,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ROOM CARD
  // ---------------------------------------------------------------------------

  Widget _roomCard(Room room) {
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
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white54,
                ),
                color: darkBg2,
                onSelected: (value) {
                  if (value == 'edit') {
                    _showRoomDialog(room: room);
                  } else if (value == 'status') {
                    _showStatusDialog(room);
                  } else if (value == 'delete') {
                    _confirmDelete(room);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(
                      'Edit Room',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'status',
                    child: Text(
                      'Update Status',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Delete Room',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _infoChip(Icons.ac_unit_rounded, room.airConditioning.label),
              _infoChip(Icons.bathtub_outlined, room.bathroomType.label),
              _infoChip(Icons.king_bed_outlined, room.bedType.label),
              _infoChip(
                Icons.people_outline_rounded,
                '${room.capacity} Guests',
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Room Rate',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${room.roomRate.toStringAsFixed(0)} / night',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _statusBadge(room.status),
            ],
          ),

          if (room.location.isNotEmpty) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white38,
                  size: 15,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    room.location,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],

          if (room.extraBedAvailable) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.add_circle_outline_rounded,
                  color: mintAccent,
                  size: 15,
                ),
                const SizedBox(width: 6),
                Text(
                  'Extra bed • ₹${room.extraBedCharge.toStringAsFixed(0)}',
                  style: const TextStyle(color: mintAccent, fontSize: 12),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INFO CHIP
  // ---------------------------------------------------------------------------

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white54, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STATUS BADGE
  // ---------------------------------------------------------------------------

  Widget _statusBadge(RoomStatus status) {
    Color color;

    switch (status) {
      case RoomStatus.available:
        color = Colors.greenAccent;
        break;
      case RoomStatus.occupied:
        color = Colors.amber;
        break;
      case RoomStatus.reserved:
        color = Colors.lightBlueAccent;
        break;
      case RoomStatus.cleaning:
        color = Colors.orangeAccent;
        break;
      case RoomStatus.maintenance:
        color = Colors.redAccent;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// =============================================================================
// ROOM FORM RESULT
// =============================================================================

class RoomFormResult {
  final bool isEditing;
  final String? roomId;

  final String roomNumber;
  final String floor;
  final RoomCategory roomCategory;
  final String location;

  final AirConditioning airConditioning;
  final BathroomType bathroomType;
  final BedType bedType;

  final int capacity;
  final double roomRate;

  final bool extraBedAvailable;
  final double extraBedCharge;

  const RoomFormResult({
    required this.isEditing,
    required this.roomId,
    required this.roomNumber,
    required this.floor,
    required this.roomCategory,
    required this.location,
    required this.airConditioning,
    required this.bathroomType,
    required this.bedType,
    required this.capacity,
    required this.roomRate,
    required this.extraBedAvailable,
    required this.extraBedCharge,
  });
}

// =============================================================================
// ROOM FORM DIALOG
// =============================================================================

class RoomFormDialog extends StatefulWidget {
  final Room? room;

  const RoomFormDialog({super.key, this.room});

  @override
  State<RoomFormDialog> createState() => _RoomFormDialogState();
}

class _RoomFormDialogState extends State<RoomFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController roomNumberController;
  late final TextEditingController floorController;
  late final TextEditingController capacityController;
  late final TextEditingController roomRateController;
  late final TextEditingController locationController;
  late final TextEditingController extraBedChargeController;

  late RoomCategory roomCategory;
  late AirConditioning airConditioning;
  late BathroomType bathroomType;
  late BedType bedType;

  late bool extraBedAvailable;

  @override
  void initState() {
    super.initState();

    final room = widget.room;

    roomNumberController = TextEditingController(text: room?.roomNumber ?? '');

    floorController = TextEditingController(text: room?.floor ?? '');

    capacityController = TextEditingController(
      text: room?.capacity.toString() ?? '2',
    );

    roomRateController = TextEditingController(
      text: room != null ? room.roomRate.toStringAsFixed(0) : '',
    );

    locationController = TextEditingController(text: room?.location ?? '');

    extraBedChargeController = TextEditingController(
      text: room != null ? room.extraBedCharge.toStringAsFixed(0) : '',
    );

    roomCategory = room?.roomCategory ?? RoomCategory.single;

    airConditioning = room?.airConditioning ?? AirConditioning.ac;

    bathroomType = room?.bathroomType ?? BathroomType.attached;

    bedType = room?.bedType ?? BedType.single;

    extraBedAvailable = room?.extraBedAvailable ?? false;
  }

  @override
  void dispose() {
    roomNumberController.dispose();
    floorController.dispose();
    capacityController.dispose();
    roomRateController.dispose();
    locationController.dispose();
    extraBedChargeController.dispose();

    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // SUBMIT
  // ---------------------------------------------------------------------------

  void _submit() {
    // Validate every mandatory field.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final roomNumber = roomNumberController.text.trim();

    final floor = floorController.text.trim();

    final location = locationController.text.trim();

    final capacity = int.tryParse(capacityController.text.trim()) ?? 0;

    final roomRate = double.tryParse(roomRateController.text.trim()) ?? 0;

    final extraBedCharge =
        double.tryParse(extraBedChargeController.text.trim()) ?? 0;

    Navigator.of(context).pop(
      RoomFormResult(
        isEditing: widget.room != null,
        roomId: widget.room?.id,
        roomNumber: roomNumber,
        floor: floor,
        roomCategory: roomCategory,
        location: location,
        airConditioning: airConditioning,
        bathroomType: bathroomType,
        bedType: bedType,
        capacity: capacity,
        roomRate: roomRate,
        extraBedAvailable: extraBedAvailable,
        extraBedCharge: extraBedAvailable ? extraBedCharge : 0,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DIALOG UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.room != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 750, maxHeight: 820),
        child: Container(
          decoration: BoxDecoration(
            color: darkBg2,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.50),
                blurRadius: 35,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            children: [
              // ===============================================================
              // HEADER
              // ===============================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 22, 24, 16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: mintAccent.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.bed_rounded,
                        color: mintAccent,
                        size: 25,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing ? 'Edit Room' : 'Add New Room',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isEditing
                                ? 'Update room information'
                                : 'Enter the details for your new room',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white54,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: Colors.white10),

              // ===============================================================
              // FORM
              // ===============================================================
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 22, 28, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -----------------------------------------------------
                        // BASIC INFORMATION
                        // -----------------------------------------------------
                        _sectionTitle('Basic information'),

                        const SizedBox(height: 12),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            final wide = constraints.maxWidth > 500;

                            if (wide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _textField(
                                      controller: roomNumberController,
                                      label: 'Room Number',
                                      hint: 'e.g. 101',
                                      icon: Icons.door_front_door_outlined,
                                      requiredField: true,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: _textField(
                                      controller: floorController,
                                      label: 'Floor',
                                      hint: 'e.g. 1',
                                      icon: Icons.layers_outlined,
                                      requiredField: true,
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                _textField(
                                  controller: roomNumberController,
                                  label: 'Room Number',
                                  hint: 'e.g. 101',
                                  icon: Icons.door_front_door_outlined,
                                  requiredField: true,
                                ),
                                const SizedBox(height: 12),
                                _textField(
                                  controller: floorController,
                                  label: 'Floor',
                                  hint: 'e.g. 1',
                                  icon: Icons.layers_outlined,
                                  requiredField: true,
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        _dropdownField<RoomCategory>(
                          label: 'Room Type',
                          icon: Icons.hotel_outlined,
                          value: roomCategory,
                          items: RoomCategory.values,
                          labelBuilder: (value) => value.label,
                          onChanged: (value) {
                            if (value == null) return;

                            setState(() {
                              roomCategory = value;
                            });
                          },
                        ),

                        const SizedBox(height: 26),

                        // -----------------------------------------------------
                        // ROOM FACILITIES
                        // -----------------------------------------------------
                        _sectionTitle('Room facilities'),

                        const SizedBox(height: 12),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            final wide = constraints.maxWidth > 650;

                            final ac = _dropdownField<AirConditioning>(
                              label: 'Air Conditioning',
                              icon: Icons.ac_unit_rounded,
                              value: airConditioning,
                              items: AirConditioning.values,
                              labelBuilder: (value) => value.label,
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }

                                setState(() {
                                  airConditioning = value;
                                });
                              },
                            );

                            final bathroom = _dropdownField<BathroomType>(
                              label: 'Bathroom',
                              icon: Icons.bathtub_outlined,
                              value: bathroomType,
                              items: BathroomType.values,
                              labelBuilder: (value) => value.label,
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }

                                setState(() {
                                  bathroomType = value;
                                });
                              },
                            );

                            final bed = _dropdownField<BedType>(
                              label: 'Bed Type',
                              icon: Icons.king_bed_outlined,
                              value: bedType,
                              items: BedType.values,
                              labelBuilder: (value) => value.label,
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }

                                setState(() {
                                  bedType = value;
                                });
                              },
                            );

                            if (wide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: ac),
                                  const SizedBox(width: 12),
                                  Expanded(child: bathroom),
                                  const SizedBox(width: 12),
                                  Expanded(child: bed),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                ac,
                                const SizedBox(height: 12),
                                bathroom,
                                const SizedBox(height: 12),
                                bed,
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            final wide = constraints.maxWidth > 500;

                            final capacity = _textField(
                              controller: capacityController,
                              label: 'Guest Capacity',
                              hint: 'e.g. 2',
                              icon: Icons.people_outline_rounded,
                              keyboardType: TextInputType.number,
                              requiredField: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Fill this field';
                                }

                                final number = int.tryParse(value.trim());

                                if (number == null || number <= 0) {
                                  return 'Enter a valid number';
                                }

                                return null;
                              },
                            );

                            final rate = _textField(
                              controller: roomRateController,
                              label: 'Room Rate / Night',
                              hint: 'e.g. 2500',
                              icon: Icons.currency_rupee_rounded,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              requiredField: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Fill this field';
                                }

                                final number = double.tryParse(value.trim());

                                if (number == null || number <= 0) {
                                  return 'Enter a valid amount';
                                }

                                return null;
                              },
                            );

                            if (wide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: capacity),
                                  const SizedBox(width: 14),
                                  Expanded(child: rate),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                capacity,
                                const SizedBox(height: 12),
                                rate,
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 26),

                        // -----------------------------------------------------
                        // ADDITIONAL DETAILS
                        // -----------------------------------------------------
                        _sectionTitle('Additional details'),

                        const SizedBox(height: 12),

                        _textField(
                          controller: locationController,
                          label: 'Location / View',
                          hint: 'e.g. Garden view',
                          icon: Icons.location_on_outlined,
                        ),

                        const SizedBox(height: 14),

                        // EXTRA BED
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
                          decoration: BoxDecoration(
                            color: cardGlass,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: darkBg2,
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: const Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: mintAccent,
                                  size: 21,
                                ),
                              ),

                              const SizedBox(width: 12),

                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Extra Bed Available',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Allow guests to request an extra bed',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Switch(
                                value: extraBedAvailable,
                                activeThumbColor: mintAccent,
                                onChanged: (value) {
                                  setState(() {
                                    extraBedAvailable = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        if (extraBedAvailable) ...[
                          const SizedBox(height: 12),
                          _textField(
                            controller: extraBedChargeController,
                            label: 'Extra Bed Charge',
                            hint: 'e.g. 500',
                            icon: Icons.currency_rupee_rounded,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ],

                        const SizedBox(height: 14),

                        // INFO BOX
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: cardGlass,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: mintAccent,
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'New rooms are automatically created with Available status.',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ===============================================================
              // FOOTER
              // ===============================================================
              const Divider(height: 1, color: Colors.white10),

              Padding(
                padding: const EdgeInsets.fromLTRB(28, 12, 28, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ),

                    const SizedBox(width: 12),

                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mintAccent,
                        foregroundColor: darkBg2,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: Text(
                        isEditing ? 'Save Changes' : 'Add Room',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION TITLE
  // ---------------------------------------------------------------------------

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TEXT FIELD
  // ---------------------------------------------------------------------------

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool requiredField = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      validator:
          validator ??
          (requiredField
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Fill this field';
                  }
                  return null;
                }
              : null),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 11),
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
        prefixIcon: Icon(icon, color: Colors.white38, size: 18),
        filled: true,
        fillColor: cardGlass,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: mintAccent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        errorStyle: const TextStyle(
          color: Colors.redAccent,
          fontSize: 11,
          height: 1.2,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DROPDOWN
  // ---------------------------------------------------------------------------

  Widget _dropdownField<T>({
    required String label,
    required IconData icon,
    required T value,
    required List<T> items,
    required String Function(T value) labelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return SizedBox(
      height: 52,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        dropdownColor: darkBg2,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54, fontSize: 11),
          prefixIcon: Icon(icon, color: Colors.white38, size: 18),
          filled: true,
          fillColor: cardGlass,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: mintAccent),
          ),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  labelBuilder(item),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
