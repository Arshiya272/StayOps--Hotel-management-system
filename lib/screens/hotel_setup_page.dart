import 'package:flutter/material.dart';
import '../widgets/app_shell.dart';
import '../models/hotel_data.dart';

class HotelSetupPage extends StatefulWidget {
  const HotelSetupPage({super.key});

  @override
  State<HotelSetupPage> createState() => _HotelSetupPageState();
}

class _HotelSetupPageState extends State<HotelSetupPage> {
  static const mintAccent = Color(0xFFB7F5C8);
  static const darkText = Color(0xFF0D1A13);
  static const cardGlass = Color(0x18FFFFFF);

  late final TextEditingController _nameController;
  late final TextEditingController _typeController;
  late final TextEditingController _contactController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _locationController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final current = HotelData.notifier.value;

    _nameController = TextEditingController(text: current.name);
    _typeController = TextEditingController(text: current.type);
    _contactController = TextEditingController(text: current.contact);
    _emailController = TextEditingController(text: current.email);
    _addressController = TextEditingController(text: current.address);
    _locationController = TextEditingController(text: current.location);

    _isEditing = current.isEmpty;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() => _isEditing = true);
  }

  void _cancelEditing() {
    final current = HotelData.notifier.value;

    _nameController.text = current.name;
    _typeController.text = current.type;
    _contactController.text = current.contact;
    _emailController.text = current.email;
    _addressController.text = current.address;
    _locationController.text = current.location;

    setState(() => _isEditing = false);
  }

  void _save() {
    final name = _nameController.text.trim();
    final type = _typeController.text.trim();
    final contact = _contactController.text.trim();
    final email = _emailController.text.trim();
    final address = _addressController.text.trim();
    final location = _locationController.text.trim();

    if (name.isEmpty || type.isEmpty || contact.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in Hotel Name, Type, Contact and Email.'),
        ),
      );
      return;
    }

    HotelData.notifier.value = HotelInfo(
      name: name,
      type: type,
      contact: contact,
      email: email,
      address: address,
      location: location,
    );

    setState(() => _isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hotel details saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentSection: AppSection.hotelSetup,
      child: ValueListenableBuilder<HotelInfo>(
        valueListenable: HotelData.notifier,
        builder: (context, data, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32, 28, 32, 40),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(data),
                    const SizedBox(height: 28),
                    _buildProfileCard(data),
                    const SizedBox(height: 22),
                    _buildTipCard(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(HotelInfo data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hotel Setup',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                data.isEmpty
                    ? 'Add your hotel information to get started.'
                    : 'Manage your hotel information and contact details.',
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
        ),
        if (!_isEditing && !data.isEmpty)
          ElevatedButton.icon(
            onPressed: _startEditing,
            icon: const Icon(Icons.edit_outlined, size: 17),
            label: const Text('Edit Details'),
            style: ElevatedButton.styleFrom(
              backgroundColor: mintAccent,
              foregroundColor: darkText,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileCard(HotelInfo data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardGlass,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(28),
      child: _isEditing ? _buildForm() : _buildReadOnly(data),
    );
  }

  Widget _buildReadOnly(HotelInfo data) {
    if (data.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: mintAccent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: mintAccent,
              size: 28,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Your hotel profile is empty',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Enter the hotel details below. These details identify the property throughout StayOps.',
            style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 22),
          ElevatedButton.icon(
            onPressed: _startEditing,
            icon: const Icon(Icons.add_rounded, size: 19),
            label: const Text('Add Hotel Details'),
            style: ElevatedButton.styleFrom(
              backgroundColor: mintAccent,
              foregroundColor: darkText,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: mintAccent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.apartment_rounded,
                color: mintAccent,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    data.type,
                    style: const TextStyle(
                      color: mintAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        const Divider(color: Colors.white10, height: 1),
        const SizedBox(height: 8),
        _infoRow(Icons.phone_outlined, 'Contact Number', data.contact),
        _infoRow(Icons.mail_outline_rounded, 'Email', data.email),
        _infoRow(Icons.location_on_outlined, 'Address', data.address),
        _infoRow(Icons.map_outlined, 'Location', data.location),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hotel Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Provide the main details of your property.',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final twoColumns = constraints.maxWidth >= 720;
            final width = twoColumns
                ? (constraints.maxWidth - 18) / 2
                : constraints.maxWidth;

            return Wrap(
              spacing: 18,
              runSpacing: 18,
              children: [
                SizedBox(
                  width: width,
                  child: _formField(
                    'Hotel Name',
                    _nameController,
                    Icons.apartment_rounded,
                    hint: 'e.g. Grand Palace Hotel',
                    requiredField: true,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: _formField(
                    'Hotel Type',
                    _typeController,
                    Icons.category_outlined,
                    hint: 'e.g. Hotel, Resort, Lodge',
                    requiredField: true,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: _formField(
                    'Contact Number',
                    _contactController,
                    Icons.phone_outlined,
                    hint: '+91 98765 43210',
                    requiredField: true,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: _formField(
                    'Email',
                    _emailController,
                    Icons.mail_outline_rounded,
                    hint: 'contact@yourhotel.com',
                    requiredField: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: _formField(
                    'Address',
                    _addressController,
                    Icons.location_on_outlined,
                    hint: 'Street, area, city',
                  ),
                ),
                SizedBox(
                  width: width,
                  child: _formField(
                    'Location',
                    _locationController,
                    Icons.map_outlined,
                    hint: 'e.g. Pollachi, Tamil Nadu',
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text('Save Hotel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: mintAccent,
                foregroundColor: darkText,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (!HotelData.notifier.value.isEmpty)
              TextButton(
                onPressed: _cancelEditing,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white60,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                ),
                child: const Text('Cancel'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _formField(
    String label,
    TextEditingController controller,
    IconData icon, {
    String? hint,
    bool requiredField = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            children: [
              if (requiredField)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: mintAccent),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.white38, size: 20),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: mintAccent, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: mintAccent.withOpacity(0.09),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: mintAccent, size: 19),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 3),
                Text(
                  value.isEmpty ? 'Not provided' : value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: mintAccent.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: mintAccent.withOpacity(0.15)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: mintAccent, size: 21),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Hotel Setup comes first because the rooms and later hotel operations will belong to this property profile.',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
