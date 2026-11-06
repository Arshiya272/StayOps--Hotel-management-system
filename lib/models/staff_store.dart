import 'package:flutter/foundation.dart';

import 'staff.dart';

class StaffStore extends ChangeNotifier {
  StaffStore._();

  static final StaffStore instance = StaffStore._();

  // Demo hotel ID.
  // Later this will come from the verified hotel's actual Hotel ID.
  final String hotelId = 'HTL-001';

  final List<Staff> _staff = [];

  List<Staff> get staff => List.unmodifiable(_staff);

  int get totalStaff => _staff.length;

  int get activeStaff => _staff.where((staff) => staff.isActive).length;

  int get inactiveStaff => _staff.where((staff) => !staff.isActive).length;

  List<Staff> getStaffByRole(StaffRole role) {
    return _staff.where((staff) => staff.role == role).toList();
  }

  Staff? getStaffById(String staffId) {
    for (final staff in _staff) {
      if (staff.staffId == staffId) {
        return staff;
      }
    }

    return null;
  }

  Staff createStaff({
    required String name,
    required String email,
    required String phone,
    required StaffRole role,
    String? customRole,
  }) {
    final number = (_staff.length + 1).toString().padLeft(3, '0');

    final staffId = 'ST-$hotelId-$number';

    final password = _generatePassword();

    final staff = Staff(
      staffId: staffId,
      hotelId: hotelId,
      name: name,
      email: email,
      phone: phone,
      role: role,
      customRole: customRole,
      password: password,
      createdAt: DateTime.now(),
    );

    _staff.insert(0, staff);

    notifyListeners();

    return staff;
  }

  String _generatePassword() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final code = timestamp.toString().substring(7);

    return 'Stay@$code';
  }

  void toggleStaffStatus(String staffId) {
    final staff = getStaffById(staffId);

    if (staff == null) {
      return;
    }

    staff.isActive = !staff.isActive;

    notifyListeners();
  }

  void removeStaff(String staffId) {
    _staff.removeWhere((staff) => staff.staffId == staffId);

    notifyListeners();
  }

  void clearStaff() {
    _staff.clear();
    notifyListeners();
  }
}
