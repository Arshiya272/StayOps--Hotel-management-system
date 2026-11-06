class ServiceRequest {
  final String id;
  final String guestName;
  final String roomNumber;
  final String serviceType;
  final String remark;
  final DateTime createdAt;

  String status;

  String? assignedStaffId;
  String? assignedStaffName;

  // Timer timestamps
  DateTime? assignedAt;
  DateTime? acceptedAt;
  DateTime? completedAt;

  ServiceRequest({
    required this.id,
    required this.guestName,
    required this.roomNumber,
    required this.serviceType,
    required this.remark,
    required this.createdAt,
    this.status = 'Pending',
    this.assignedStaffId,
    this.assignedStaffName,
    this.assignedAt,
    this.acceptedAt,
    this.completedAt,
  });
}
