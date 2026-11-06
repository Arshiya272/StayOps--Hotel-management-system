enum StaffRole {
  frontDesk,
  housekeeping,
  maintenance,
  roomService,
  accounts,
  security,
  inventory,
  manager,
  custom,
}

extension StaffRoleExtension on StaffRole {
  String get label {
    switch (this) {
      case StaffRole.frontDesk:
        return 'Front Desk';
      case StaffRole.housekeeping:
        return 'Housekeeping';
      case StaffRole.maintenance:
        return 'Maintenance';
      case StaffRole.roomService:
        return 'Room Service';
      case StaffRole.accounts:
        return 'Accounts';
      case StaffRole.security:
        return 'Security';
      case StaffRole.inventory:
        return 'Inventory';
      case StaffRole.manager:
        return 'Manager';
      case StaffRole.custom:
        return 'Custom Role';
    }
  }
}

class Staff {
  final String staffId;
  final String hotelId;
  final String name;
  final String email;
  final String phone;
  final StaffRole role;
  final String? customRole;
  final String password;
  final DateTime createdAt;

  bool isActive;

  Staff({
    required this.staffId,
    required this.hotelId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.password,
    required this.createdAt,
    this.customRole,
    this.isActive = true,
  });

  String get roleName {
    if (role == StaffRole.custom &&
        customRole != null &&
        customRole!.trim().isNotEmpty) {
      return customRole!;
    }

    return role.label;
  }
}
