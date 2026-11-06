import 'package:flutter/foundation.dart';

import 'service_request.dart';

class ServiceRequestStore extends ChangeNotifier {
  ServiceRequestStore._();

  static final ServiceRequestStore instance = ServiceRequestStore._();

  final List<ServiceRequest> _requests = [];

  List<ServiceRequest> get requests => List.unmodifiable(_requests);

  // Number of requests currently waiting for admin action.
  int get pendingCount {
    return _requests.where((request) => request.status == 'Pending').length;
  }

  // ============================================================
  // ADD REQUEST
  // ============================================================

  void addRequest(ServiceRequest request) {
    _requests.insert(0, request);
    notifyListeners();
  }

  // ============================================================
  // FIND REQUEST
  // ============================================================

  ServiceRequest? getRequestById(String id) {
    for (final request in _requests) {
      if (request.id == id) {
        return request;
      }
    }

    return null;
  }

  // ============================================================
  // PENDING REQUESTS
  // ============================================================

  List<ServiceRequest> getPendingRequests() {
    return _requests.where((request) => request.status == 'Pending').toList();
  }

  // ============================================================
  // ASSIGNED REQUESTS
  // ============================================================

  List<ServiceRequest> getAssignedRequests(String staffId) {
    return _requests
        .where(
          (request) =>
              request.assignedStaffId == staffId &&
              request.status == 'Assigned',
        )
        .toList();
  }

  // ============================================================
  // IN PROGRESS REQUESTS
  // ============================================================

  List<ServiceRequest> getInProgressRequests(String staffId) {
    return _requests
        .where(
          (request) =>
              request.assignedStaffId == staffId &&
              request.status == 'In Progress',
        )
        .toList();
  }

  // ============================================================
  // COMPLETED REQUESTS
  // ============================================================

  List<ServiceRequest> getCompletedRequests(String staffId) {
    return _requests
        .where(
          (request) =>
              request.assignedStaffId == staffId &&
              request.status == 'Completed',
        )
        .toList();
  }

  // ============================================================
  // ASSIGN STAFF
  // ============================================================

  void assignStaff({
    required String requestId,
    required String staffId,
    required String staffName,
  }) {
    final request = getRequestById(requestId);

    if (request == null) {
      return;
    }

    request.assignedStaffId = staffId;
    request.assignedStaffName = staffName;

    // Acceptance timer starts here.
    request.assignedAt = DateTime.now();

    request.status = 'Assigned';

    notifyListeners();
  }

  // ============================================================
  // ACCEPT REQUEST
  // ============================================================

  void acceptRequest(String requestId) {
    final request = getRequestById(requestId);

    if (request == null) {
      return;
    }

    request.acceptedAt = DateTime.now();
    request.status = 'In Progress';

    notifyListeners();
  }

  // ============================================================
  // COMPLETE REQUEST
  // ============================================================

  void completeRequest(String requestId) {
    final request = getRequestById(requestId);

    if (request == null) {
      return;
    }

    request.completedAt = DateTime.now();
    request.status = 'Completed';

    notifyListeners();
  }

  // ============================================================
  // ACCEPTANCE DURATION
  // ============================================================

  Duration? getAcceptanceDuration(ServiceRequest request) {
    if (request.assignedAt == null) {
      return null;
    }

    final end = request.acceptedAt ?? DateTime.now();

    return end.difference(request.assignedAt!);
  }

  // ============================================================
  // SERVICE DURATION
  // ============================================================

  Duration? getServiceDuration(ServiceRequest request) {
    if (request.acceptedAt == null) {
      return null;
    }

    final end = request.completedAt ?? DateTime.now();

    return end.difference(request.acceptedAt!);
  }

  // ============================================================
  // OVERDUE
  // ============================================================

  bool isOverdue(
    ServiceRequest request, {
    Duration limit = const Duration(minutes: 10),
  }) {
    if (request.assignedAt == null) {
      return false;
    }

    if (request.acceptedAt != null) {
      return false;
    }

    final elapsed = DateTime.now().difference(request.assignedAt!);

    return elapsed > limit;
  }

  // ============================================================
  // ACCEPTANCE STATUS
  // ============================================================

  String getAcceptanceStatus(
    ServiceRequest request, {
    Duration warningTime = const Duration(minutes: 5),
    Duration overdueTime = const Duration(minutes: 10),
  }) {
    if (request.assignedAt == null) {
      return 'Not Assigned';
    }

    if (request.acceptedAt != null) {
      return 'Accepted';
    }

    final elapsed = DateTime.now().difference(request.assignedAt!);

    if (elapsed >= overdueTime) {
      return 'Overdue';
    }

    if (elapsed >= warningTime) {
      return 'Delayed';
    }

    return 'Waiting';
  }

  // ============================================================
  // CLEAR REQUESTS
  // ============================================================

  void clearRequests() {
    _requests.clear();
    notifyListeners();
  }
}
