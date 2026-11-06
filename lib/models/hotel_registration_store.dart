import 'dart:convert';
import 'dart:html' as html;

import 'hotel_registration.dart';

class HotelRegistrationStore {
  HotelRegistrationStore._() {
    _loadRegistrations();
  }

  static final HotelRegistrationStore instance = HotelRegistrationStore._();

  static const String _storageKey = 'stayops_hotel_registrations';

  final List<HotelRegistration> _registrations = [];

  List<HotelRegistration> get registrations =>
      List.unmodifiable(_registrations);

  // =========================
  // LOAD FROM BROWSER STORAGE
  // =========================
  void _loadRegistrations() {
    try {
      final savedData = html.window.localStorage[_storageKey];

      if (savedData == null || savedData.isEmpty) {
        return;
      }

      final List<dynamic> decoded = jsonDecode(savedData);

      _registrations.clear();

      for (final item in decoded) {
        _registrations.add(
          HotelRegistration(
            id: item['id'],
            hotelName: item['hotelName'],
            ownerManager: item['ownerManager'],
            address: item['address'],
            city: item['city'],
            state: item['state'],
            pinCode: item['pinCode'],
            numberOfRooms: item['numberOfRooms'],
            phone: item['phone'],
            officialEmail: item['officialEmail'],
            website: item['website'],
            registrationNumber: item['registrationNumber'],
            verificationDetails: item['verificationDetails'],
            status: item['status'] ?? 'Pending',
            hotelId: item['hotelId'],
            adminId: item['adminId'],
            adminPassword: item['adminPassword'],
            submittedAt: DateTime.parse(item['submittedAt']),
          ),
        );
      }
    } catch (e) {
      // Ignore corrupted local storage data.
      _registrations.clear();
    }
  }

  // =========================
  // SAVE TO BROWSER STORAGE
  // =========================
  void _saveRegistrations() {
    final data = _registrations.map((registration) {
      return {
        'id': registration.id,
        'hotelName': registration.hotelName,
        'ownerManager': registration.ownerManager,
        'address': registration.address,
        'city': registration.city,
        'state': registration.state,
        'pinCode': registration.pinCode,
        'numberOfRooms': registration.numberOfRooms,
        'phone': registration.phone,
        'officialEmail': registration.officialEmail,
        'website': registration.website,
        'registrationNumber': registration.registrationNumber,
        'verificationDetails': registration.verificationDetails,
        'status': registration.status,
        'hotelId': registration.hotelId,
        'adminId': registration.adminId,
        'adminPassword': registration.adminPassword,
        'submittedAt': registration.submittedAt.toIso8601String(),
      };
    }).toList();

    html.window.localStorage[_storageKey] = jsonEncode(data);
  }

  // =========================
  // ADD REGISTRATION
  // =========================
  void addRegistration(HotelRegistration registration) {
    _registrations.insert(0, registration);
    _saveRegistrations();
  }

  // =========================
  // GET BY ID
  // =========================
  HotelRegistration? getById(String id) {
    for (final registration in _registrations) {
      if (registration.id == id) {
        return registration;
      }
    }

    return null;
  }

  // =========================
  // UPDATE STATUS
  // =========================
  void updateStatus(String id, String status) {
    final registration = getById(id);

    if (registration == null) return;

    registration.status = status;

    _saveRegistrations();
  }

  // =========================
  // APPROVE REGISTRATION
  // =========================
  void approveRegistration({
    required String id,
    required String hotelId,
    required String adminId,
    required String adminPassword,
  }) {
    final registration = getById(id);

    if (registration == null) return;

    registration.status = 'Approved';
    registration.hotelId = hotelId;
    registration.adminId = adminId;
    registration.adminPassword = adminPassword;

    _saveRegistrations();
  }

  // =========================
  // REJECT REGISTRATION
  // =========================
  void rejectRegistration(String id) {
    final registration = getById(id);

    if (registration == null) return;

    registration.status = 'Rejected';

    _saveRegistrations();
  }

  // =========================
  // PENDING
  // =========================
  List<HotelRegistration> getPendingRegistrations() {
    return _registrations
        .where((registration) => registration.status == 'Pending')
        .toList();
  }

  // =========================
  // APPROVED
  // =========================
  List<HotelRegistration> getApprovedRegistrations() {
    return _registrations
        .where((registration) => registration.status == 'Approved')
        .toList();
  }

  // =========================
  // REJECTED
  // =========================
  List<HotelRegistration> getRejectedRegistrations() {
    return _registrations
        .where((registration) => registration.status == 'Rejected')
        .toList();
  }

  // =========================
  // CLEAR
  // =========================
  void clearRegistrations() {
    _registrations.clear();
    html.window.localStorage.remove(_storageKey);
  }
}
