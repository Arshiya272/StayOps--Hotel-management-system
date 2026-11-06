class HotelRegistration {
  final String id;

  final String hotelName;
  final String ownerManager;
  final String address;
  final String city;
  final String state;
  final String pinCode;
  final String numberOfRooms;

  final String phone;
  final String officialEmail;
  final String website;

  final String registrationNumber;
  final String verificationDetails;

  String status;

  String? hotelId;
  String? adminId;
  String? adminPassword;

  final DateTime submittedAt;

  HotelRegistration({
    required this.id,
    required this.hotelName,
    required this.ownerManager,
    required this.address,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.numberOfRooms,
    required this.phone,
    required this.officialEmail,
    required this.website,
    required this.registrationNumber,
    required this.verificationDetails,
    this.status = 'Pending',
    this.hotelId,
    this.adminId,
    this.adminPassword,
    required this.submittedAt,
  });
}
