import 'package:flutter/material.dart';

import '../models/hotel_registration.dart';
import '../models/hotel_registration_store.dart';

class HotelRegistrationPage extends StatefulWidget {
  const HotelRegistrationPage({super.key});

  @override
  State<HotelRegistrationPage> createState() => _HotelRegistrationPageState();
}

class _HotelRegistrationPageState extends State<HotelRegistrationPage> {
  final Color darkBg = const Color(0xFF13241B);
  final Color darkBg2 = const Color(0xFF0D1A13);
  final Color mintAccent = const Color(0xFFB7F5C8);

  final _formKey = GlobalKey<FormState>();

  final hotelNameController = TextEditingController();
  final ownerController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final roomsController = TextEditingController();
  final registrationController = TextEditingController();
  final verificationController = TextEditingController();

  @override
  void dispose() {
    hotelNameController.dispose();
    ownerController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pinController.dispose();
    phoneController.dispose();
    emailController.dispose();
    websiteController.dispose();
    roomsController.dispose();
    registrationController.dispose();
    verificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 70,
                  vertical: 35,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 950),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),

                          const SizedBox(height: 30),

                          _sectionTitle(
                            'Hotel Information',
                            'Tell us about your hotel.',
                          ),

                          const SizedBox(height: 18),

                          _buildCard(
                            children: [
                              _field(
                                controller: hotelNameController,
                                label: 'Hotel Name',
                                hint: 'Enter hotel name',
                                icon: Icons.hotel_outlined,
                              ),

                              const SizedBox(height: 18),

                              _field(
                                controller: ownerController,
                                label: 'Owner / Manager Name',
                                hint: 'Enter owner or manager name',
                                icon: Icons.person_outline,
                              ),

                              const SizedBox(height: 18),

                              _field(
                                controller: addressController,
                                label: 'Hotel Address',
                                hint: 'Enter complete hotel address',
                                icon: Icons.location_on_outlined,
                                maxLines: 3,
                              ),

                              const SizedBox(height: 18),

                              Row(
                                children: [
                                  Expanded(
                                    child: _field(
                                      controller: cityController,
                                      label: 'City',
                                      hint: 'Coimbatore',
                                      icon: Icons.location_city_outlined,
                                    ),
                                  ),

                                  const SizedBox(width: 18),

                                  Expanded(
                                    child: _field(
                                      controller: stateController,
                                      label: 'State',
                                      hint: 'Tamil Nadu',
                                      icon: Icons.map_outlined,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              Row(
                                children: [
                                  Expanded(
                                    child: _field(
                                      controller: pinController,
                                      label: 'PIN Code',
                                      hint: '641001',
                                      icon: Icons.pin_drop_outlined,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),

                                  const SizedBox(width: 18),

                                  Expanded(
                                    child: _field(
                                      controller: roomsController,
                                      label: 'Number of Rooms',
                                      hint: '50',
                                      icon: Icons.meeting_room_outlined,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          _sectionTitle(
                            'Contact Information',
                            'How can StayOps contact the hotel?',
                          ),

                          const SizedBox(height: 18),

                          _buildCard(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _field(
                                      controller: phoneController,
                                      label: 'Phone Number',
                                      hint: '+91 XXXXX XXXXX',
                                      icon: Icons.phone_outlined,
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),

                                  const SizedBox(width: 18),

                                  Expanded(
                                    child: _field(
                                      controller: emailController,
                                      label: 'Official Email',
                                      hint: 'hotel@example.com',
                                      icon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              _field(
                                controller: websiteController,
                                label: 'Website',
                                hint: 'https://example.com',
                                icon: Icons.language_outlined,
                                requiredField: false,
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          _sectionTitle(
                            'Verification Details',
                            'These details will be reviewed by the Main Admin.',
                          ),

                          const SizedBox(height: 18),

                          _buildCard(
                            children: [
                              _field(
                                controller: registrationController,
                                label: 'Hotel Registration / License Number',
                                hint: 'Enter registration or license number',
                                icon: Icons.badge_outlined,
                              ),

                              const SizedBox(height: 18),

                              _field(
                                controller: verificationController,
                                label: 'Additional Verification Details',
                                hint:
                                    'Provide any additional information that helps verify the hotel.',
                                icon: Icons.description_outlined,
                                maxLines: 5,
                              ),

                              const SizedBox(height: 20),

                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: mintAccent.withOpacity(0.07),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: mintAccent.withOpacity(0.12),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.info_outline, color: mintAccent),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Your registration will be reviewed by the StayOps Main Admin. Hotel access will only be provided after approval.',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.65),
                                          fontSize: 12,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          _buildSubmitButton(),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: darkBg,
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white.withOpacity(0.75),
            ),
          ),

          const SizedBox(width: 10),

          Text(
            'STAYOPS',
            style: TextStyle(
              color: mintAccent,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(width: 12),

          Container(
            width: 1,
            height: 25,
            color: Colors.white.withOpacity(0.12),
          ),

          const SizedBox(width: 12),

          Text(
            'Hotel Registration',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Register your hotel',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Submit your hotel details for verification and approval.',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          subtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: darkBg2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(children: children),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool requiredField = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      validator: requiredField
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter $label';
              }

              return null;
            }
          : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.55)),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.22)),
        prefixIcon: Icon(icon, color: mintAccent.withOpacity(0.7), size: 20),
        filled: true,
        fillColor: darkBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.07)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.07)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: mintAccent.withOpacity(0.6)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _submitRegistration,
        style: ElevatedButton.styleFrom(
          backgroundColor: mintAccent,
          foregroundColor: darkBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Submit Registration',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  void _submitRegistration() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final now = DateTime.now();

    final registration = HotelRegistration(
      id: 'REG-${now.millisecondsSinceEpoch}',
      hotelName: hotelNameController.text.trim(),
      ownerManager: ownerController.text.trim(),
      address: addressController.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      pinCode: pinController.text.trim(),
      numberOfRooms: roomsController.text.trim(),
      phone: phoneController.text.trim(),
      officialEmail: emailController.text.trim(),
      website: websiteController.text.trim(),
      registrationNumber: registrationController.text.trim(),
      verificationDetails: verificationController.text.trim(),
      status: 'Pending',
      submittedAt: now,
    );

    HotelRegistrationStore.instance.addRegistration(registration);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: darkBg2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: mintAccent),
              const SizedBox(width: 10),
              const Text(
                'Registration Submitted',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            'Your hotel registration has been submitted successfully. The StayOps Main Admin will review your details before approving access.',
            style: TextStyle(color: Colors.white.withOpacity(0.6), height: 1.5),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mintAccent,
                foregroundColor: darkBg,
              ),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
