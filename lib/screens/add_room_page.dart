import 'package:flutter/material.dart';

import '../models/room_data.dart';
import '../widgets/app_shell.dart';

class AddRoomPage extends StatefulWidget {
  final Room? room;

  const AddRoomPage({super.key, this.room});

  @override
  State<AddRoomPage> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  static const Color darkBg = Color(0xFF13241B);
  static const Color darkBg2 = Color(0xFF0D1A13);
  static const Color cardBg = Color(0xFF182D22);
  static const Color mintAccent = Color(0xFFB7F5C8);

  late final TextEditingController _roomNumberController;
  late final TextEditingController _floorController;
  late final TextEditingController _locationController;
  late final TextEditingController _capacityController;
  late final TextEditingController _roomRateController;
  late final TextEditingController _extraBedChargeController;

  late RoomCategory _selectedCategory;
  late AirConditioning _selectedAc;
  late BathroomType _selectedBathroom;
  late BedType _selectedBed;

  bool _extraBedAvailable = false;

  bool get _isEditing => widget.room != null;

  @override
  void initState() {
    super.initState();

    final room = widget.room;

    _roomNumberController = TextEditingController(text: room?.roomNumber ?? '');

    _floorController = TextEditingController(text: room?.floor ?? '');

    _locationController = TextEditingController(text: room?.location ?? '');

    _capacityController = TextEditingController(
      text: room?.capacity.toString() ?? '',
    );

    _roomRateController = TextEditingController(
      text: room?.roomRate.toStringAsFixed(0) ?? '',
    );

    _extraBedChargeController = TextEditingController(
      text: room?.extraBedCharge.toStringAsFixed(0) ?? '',
    );

    _selectedCategory = room?.roomCategory ?? RoomCategory.single;

    _selectedAc = room?.airConditioning ?? AirConditioning.ac;

    _selectedBathroom = room?.bathroomType ?? BathroomType.attached;

    _selectedBed = room?.bedType ?? BedType.single;

    _extraBedAvailable = room?.extraBedAvailable ?? false;
  }

  @override
  void dispose() {
    _roomNumberController.dispose();
    _floorController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    _roomRateController.dispose();
    _extraBedChargeController.dispose();
    super.dispose();
  }

  void _saveRoom() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final roomNumber = _roomNumberController.text.trim();

    final floor = _floorController.text.trim();

    final location = _locationController.text.trim();

    final capacity = int.parse(_capacityController.text.trim());

    final roomRate = double.parse(_roomRateController.text.trim());

    final extraBedCharge = _extraBedAvailable
        ? double.parse(_extraBedChargeController.text.trim())
        : 0.0;

    if (_isEditing) {
      RoomData.updateRoom(
        id: widget.room!.id,
        roomNumber: roomNumber,
        floor: floor,
        roomCategory: _selectedCategory,
        location: location,
        airConditioning: _selectedAc,
        bathroomType: _selectedBathroom,
        bedType: _selectedBed,
        capacity: capacity,
        extraBedAvailable: _extraBedAvailable,
        extraBedCharge: extraBedCharge,
        roomRate: roomRate,
      );
    } else {
      RoomData.addRoom(
        roomNumber: roomNumber,
        floor: floor,
        roomCategory: _selectedCategory,
        location: location,
        airConditioning: _selectedAc,
        bathroomType: _selectedBathroom,
        bedType: _selectedBed,
        capacity: capacity,
        extraBedAvailable: _extraBedAvailable,
        extraBedCharge: extraBedCharge,
        roomRate: roomRate,
      );
    }

    Navigator.of(context).pop(true);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentSection: AppSection.rooms,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 28),
                _buildForm(),
              ],
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
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white70),
          tooltip: 'Back to Rooms',
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEditing ? 'Edit Room' : 'Add New Room',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _isEditing
                    ? 'Update the details of this room'
                    : 'Enter the details for your new room',
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: 'Basic information',
            icon: Icons.meeting_room_outlined,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 650;

                final roomNumber = _textField(
                  controller: _roomNumberController,
                  label: 'Room Number',
                  hint: 'e.g. 101',
                  icon: Icons.meeting_room_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter room number';
                    }

                    return null;
                  },
                );

                final floor = _textField(
                  controller: _floorController,
                  label: 'Floor',
                  hint: 'e.g. Ground / 1',
                  icon: Icons.layers_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter floor';
                    }

                    return null;
                  },
                );

                if (compact) {
                  return Column(
                    children: [roomNumber, const SizedBox(height: 16), floor],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: roomNumber),
                    const SizedBox(width: 16),
                    Expanded(child: floor),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          _buildSection(
            title: 'Room type',
            icon: Icons.king_bed_outlined,
            child: _dropdownField<RoomCategory>(
              label: 'Room Type',
              icon: Icons.king_bed_outlined,
              value: _selectedCategory,
              items: RoomCategory.values
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
          ),

          const SizedBox(height: 20),

          _buildSection(
            title: 'Room facilities',
            icon: Icons.home_work_outlined,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 700;

                final acField = _dropdownField<AirConditioning>(
                  label: 'Air Conditioning',
                  icon: Icons.ac_unit_outlined,
                  value: _selectedAc,
                  items: AirConditioning.values
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(value.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedAc = value;
                      });
                    }
                  },
                );

                final bathroomField = _dropdownField<BathroomType>(
                  label: 'Bathroom',
                  icon: Icons.bathtub_outlined,
                  value: _selectedBathroom,
                  items: BathroomType.values
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(value.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedBathroom = value;
                      });
                    }
                  },
                );

                final bedField = _dropdownField<BedType>(
                  label: 'Bed Type',
                  icon: Icons.bed_outlined,
                  value: _selectedBed,
                  items: BedType.values
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(value.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedBed = value;
                      });
                    }
                  },
                );

                if (compact) {
                  return Column(
                    children: [
                      acField,
                      const SizedBox(height: 16),
                      bathroomField,
                      const SizedBox(height: 16),
                      bedField,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: acField),
                    const SizedBox(width: 12),
                    Expanded(child: bathroomField),
                    const SizedBox(width: 12),
                    Expanded(child: bedField),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          _buildSection(
            title: 'Capacity & pricing',
            icon: Icons.payments_outlined,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 650;

                final capacity = _textField(
                  controller: _capacityController,
                  label: 'Guest Capacity',
                  hint: 'e.g. 2',
                  icon: Icons.people_outline_rounded,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed = int.tryParse(value?.trim() ?? '');

                    if (parsed == null || parsed <= 0) {
                      return 'Enter a valid capacity';
                    }

                    return null;
                  },
                );

                final rate = _textField(
                  controller: _roomRateController,
                  label: 'Room Rate / Night',
                  hint: 'e.g. 2500',
                  icon: Icons.currency_rupee_rounded,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    final parsed = double.tryParse(value?.trim() ?? '');

                    if (parsed == null || parsed < 0) {
                      return 'Enter a valid rate';
                    }

                    return null;
                  },
                );

                if (compact) {
                  return Column(
                    children: [capacity, const SizedBox(height: 16), rate],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: capacity),
                    const SizedBox(width: 16),
                    Expanded(child: rate),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          _buildSection(
            title: 'Additional details',
            icon: Icons.info_outline_rounded,
            child: Column(
              children: [
                _textField(
                  controller: _locationController,
                  label: 'Location / View',
                  hint: 'e.g. Pool View, Sea View, East Wing',
                  icon: Icons.location_on_outlined,
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.035),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.add_circle_outline_rounded,
                              color: Colors.white60,
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
                                SizedBox(height: 4),
                                Text(
                                  'Allow guests to request an extra bed',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _extraBedAvailable,
                            activeThumbColor: mintAccent,
                            activeTrackColor: mintAccent.withValues(
                              alpha: 0.25,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _extraBedAvailable = value;
                              });
                            },
                          ),
                        ],
                      ),

                      if (_extraBedAvailable) ...[
                        const SizedBox(height: 16),
                        _textField(
                          controller: _extraBedChargeController,
                          label: 'Extra Bed Charge',
                          hint: 'e.g. 500',
                          icon: Icons.currency_rupee_rounded,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (!_extraBedAvailable) {
                              return null;
                            }

                            final parsed = double.tryParse(value?.trim() ?? '');

                            if (parsed == null || parsed < 0) {
                              return 'Enter a valid charge';
                            }

                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: mintAccent.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: mintAccent.withValues(alpha: 0.12)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: mintAccent,
                  size: 19,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _isEditing
                        ? 'Saving changes will keep the room’s current status.'
                        : 'New rooms are automatically created with Available status.',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _saveRoom,
                icon: Icon(
                  _isEditing ? Icons.check_rounded : Icons.add_rounded,
                ),
                label: Text(_isEditing ? 'Save Changes' : 'Add Room'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mintAccent,
                  foregroundColor: darkBg2,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: mintAccent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: mintAccent, size: 18),
              ),
              const SizedBox(width: 11),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 12),
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
        prefixIcon: Icon(icon, color: Colors.white38, size: 19),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.035),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: mintAccent, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
      ),
    );
  }

  Widget _dropdownField<T>({
    required String label,
    required IconData icon,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      dropdownColor: darkBg2,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      iconEnabledColor: Colors.white54,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 12),
        prefixIcon: Icon(icon, color: Colors.white38, size: 19),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.035),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: mintAccent, width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
    );
  }
}
