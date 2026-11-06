import 'package:flutter/material.dart';

import '../models/staff.dart';
import '../models/staff_store.dart';
import '../widgets/app_shell.dart';

class StaffManagementPage extends StatefulWidget {
  const StaffManagementPage({super.key});

  @override
  State<StaffManagementPage> createState() => _StaffManagementPageState();
}

class _StaffManagementPageState extends State<StaffManagementPage> {
  static const darkBg = Color(0xFF13241B);
  static const darkBg2 = Color(0xFF0D1A13);
  static const mintAccent = Color(0xFFB7F5C8);
  static const cardGlass = Color(0x1AFFFFFF);

  final StaffStore _store = StaffStore.instance;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentSection: AppSection.staff,
      child: Container(
        color: darkBg,
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _store,
            builder: (context, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 28, 32, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),

                    const SizedBox(height: 28),

                    _buildStats(),

                    const SizedBox(height: 24),

                    _buildStaffSection(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Staff Management',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Add staff, assign roles and manage hotel employees.',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
        ),

        ElevatedButton.icon(
          onPressed: _showAddStaffDialog,
          icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
          label: const Text('Add Staff'),
          style: ElevatedButton.styleFrom(
            backgroundColor: mintAccent,
            foregroundColor: darkBg,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
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
            icon: Icons.groups_rounded,
            value: '${_store.totalStaff}',
            title: 'Total Staff',
            accent: mintAccent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statCard(
            icon: Icons.check_circle_outline_rounded,
            value: '${_store.activeStaff}',
            title: 'Active',
            accent: Colors.greenAccent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statCard(
            icon: Icons.pause_circle_outline_rounded,
            value: '${_store.inactiveStaff}',
            title: 'Inactive',
            accent: Colors.amber,
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
      height: 104,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardGlass,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
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

  Widget _buildStaffSection() {
    if (_store.staff.isEmpty) {
      return Container(
        width: double.infinity,
        height: 240,
        decoration: BoxDecoration(
          color: cardGlass,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_rounded, color: mintAccent, size: 48),
            SizedBox(height: 18),
            Text(
              'No staff added yet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 7),
            Text(
              'Add your first staff member to start managing hotel roles.',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardGlass,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Hotel Staff',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${_store.totalStaff} members',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                Colors.white.withOpacity(0.03),
              ),
              dataRowMinHeight: 62,
              dataRowMaxHeight: 70,
              columnSpacing: 28,
              columns: const [
                DataColumn(
                  label: Text(
                    'Staff',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Staff ID',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Role',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Contact',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Actions',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ),
              ],
              rows: _store.staff.map((staff) {
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: mintAccent.withOpacity(0.12),
                            child: Text(
                              staff.name.isEmpty
                                  ? '?'
                                  : staff.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: mintAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            staff.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Text(
                        staff.staffId,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    DataCell(_roleChip(staff.roleName)),
                    DataCell(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            staff.email,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            staff.phone,
                            style: const TextStyle(
                              color: Colors.white30,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(_statusChip(staff.isActive)),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'View Credentials',
                            onPressed: () {
                              _showCredentials(staff);
                            },
                            icon: const Icon(
                              Icons.key_outlined,
                              color: Colors.white54,
                              size: 18,
                            ),
                          ),
                          IconButton(
                            tooltip: staff.isActive ? 'Deactivate' : 'Activate',
                            onPressed: () {
                              _store.toggleStaffStatus(staff.staffId);
                            },
                            icon: Icon(
                              staff.isActive
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              color: staff.isActive
                                  ? Colors.amber
                                  : Colors.greenAccent,
                              size: 19,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Remove',
                            onPressed: () {
                              _confirmRemove(staff.staffId, staff.name);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleChip(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: mintAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: mintAccent.withOpacity(0.15)),
      ),
      child: Text(
        role,
        style: const TextStyle(
          color: mintAccent,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _statusChip(bool active) {
    final color = active ? Colors.greenAccent : Colors.amber;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Text(
        active ? 'ACTIVE' : 'INACTIVE',
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  void _showAddStaffDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    StaffRole selectedRole = StaffRole.frontDesk;

    final customRoleController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: darkBg2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Add Staff',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dialogField(
                        controller: nameController,
                        label: 'Staff Name',
                        hint: 'Enter staff name',
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 16),

                      _dialogField(
                        controller: emailController,
                        label: 'Official Email',
                        hint: 'staff@example.com',
                        icon: Icons.email_outlined,
                      ),

                      const SizedBox(height: 16),

                      _dialogField(
                        controller: phoneController,
                        label: 'Phone Number',
                        hint: '+91 XXXXX XXXXX',
                        icon: Icons.phone_outlined,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Role',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 7),

                      DropdownButtonFormField<StaffRole>(
                        value: selectedRole,
                        dropdownColor: darkBg2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.badge_outlined,
                            color: Colors.white38,
                            size: 19,
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: const BorderSide(color: Colors.white10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: const BorderSide(color: Colors.white10),
                          ),
                        ),
                        items: StaffRole.values
                            .map(
                              (role) => DropdownMenuItem(
                                value: role,
                                child: Text(role.label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          setDialogState(() {
                            selectedRole = value;
                          });
                        },
                      ),

                      if (selectedRole == StaffRole.custom) ...[
                        const SizedBox(height: 16),
                        _dialogField(
                          controller: customRoleController,
                          label: 'Custom Role',
                          hint: 'Enter custom role',
                          icon: Icons.edit_outlined,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final email = emailController.text.trim();
                    final phone = phoneController.text.trim();

                    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all staff details.'),
                        ),
                      );
                      return;
                    }

                    if (selectedRole == StaffRole.custom &&
                        customRoleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter the custom role.'),
                        ),
                      );
                      return;
                    }

                    final staff = _store.createStaff(
                      name: name,
                      email: email,
                      phone: phone,
                      role: selectedRole,
                      customRole: selectedRole == StaffRole.custom
                          ? customRoleController.text.trim()
                          : null,
                    );

                    Navigator.pop(dialogContext);

                    _showCredentials(staff);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mintAccent,
                    foregroundColor: darkBg,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Create Staff',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _dialogField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24),
            prefixIcon: Icon(icon, color: Colors.white38, size: 19),
            filled: true,
            fillColor: Colors.white.withOpacity(0.04),
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
              borderSide: const BorderSide(color: mintAccent),
            ),
          ),
        ),
      ],
    );
  }

  void _showCredentials(Staff staff) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: darkBg2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: mintAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  color: mintAccent,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Staff Created',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'These credentials would be emailed to the staff member.',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 20),

              _credentialRow('Hotel ID', staff.hotelId),

              _credentialRow('Staff ID', staff.staffId),

              _credentialRow('Email', staff.email),

              _credentialRow('Password', staff.password),

              _credentialRow('Role', staff.roleName),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
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

  Widget _credentialRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 85,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ),
          Expanded(
            child: Text(
              value,
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

  void _confirmRemove(String staffId, String staffName) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: darkBg2,
          title: const Text(
            'Remove Staff?',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Remove $staffName from this hotel?',
            style: const TextStyle(color: Colors.white60),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _store.removeStaff(staffId);

                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}
