import 'package:flutter/foundation.dart';

enum RoomCategory { single, double, deluxe, suite }

extension RoomCategoryLabel on RoomCategory {
  String get label {
    switch (this) {
      case RoomCategory.single:
        return 'Single';
      case RoomCategory.double:
        return 'Double';
      case RoomCategory.deluxe:
        return 'Deluxe';
      case RoomCategory.suite:
        return 'Suite';
    }
  }
}

enum AirConditioning { ac, nonAc }

extension AirConditioningLabel on AirConditioning {
  String get label {
    switch (this) {
      case AirConditioning.ac:
        return 'AC';
      case AirConditioning.nonAc:
        return 'Non-AC';
    }
  }
}

enum BathroomType { attached, notAttached }

extension BathroomTypeLabel on BathroomType {
  String get label {
    switch (this) {
      case BathroomType.attached:
        return 'Attached';
      case BathroomType.notAttached:
        return 'Not Attached';
    }
  }
}

enum BedType { single, double, queen, king, twin }

extension BedTypeLabel on BedType {
  String get label {
    switch (this) {
      case BedType.single:
        return 'Single Bed';
      case BedType.double:
        return 'Double Bed';
      case BedType.queen:
        return 'Queen Bed';
      case BedType.king:
        return 'King Bed';
      case BedType.twin:
        return 'Twin Beds';
    }
  }
}

enum RoomStatus { available, occupied, reserved, cleaning, maintenance }

extension RoomStatusLabel on RoomStatus {
  String get label {
    switch (this) {
      case RoomStatus.available:
        return 'Available';
      case RoomStatus.occupied:
        return 'Occupied';
      case RoomStatus.reserved:
        return 'Reserved';
      case RoomStatus.cleaning:
        return 'Cleaning';
      case RoomStatus.maintenance:
        return 'Maintenance';
    }
  }
}

class Room {
  final String id;
  final String roomNumber;
  final String floor;
  final RoomCategory roomCategory;
  final String location;
  final AirConditioning airConditioning;
  final BathroomType bathroomType;
  final BedType bedType;
  final int capacity;
  final bool extraBedAvailable;
  final double extraBedCharge;
  final double roomRate;
  final RoomStatus status;

  const Room({
    required this.id,
    required this.roomNumber,
    required this.floor,
    required this.roomCategory,
    required this.location,
    required this.airConditioning,
    required this.bathroomType,
    required this.bedType,
    required this.capacity,
    required this.extraBedAvailable,
    required this.extraBedCharge,
    required this.roomRate,
    required this.status,
  });

  Room copyWith({
    String? roomNumber,
    String? floor,
    RoomCategory? roomCategory,
    String? location,
    AirConditioning? airConditioning,
    BathroomType? bathroomType,
    BedType? bedType,
    int? capacity,
    bool? extraBedAvailable,
    double? extraBedCharge,
    double? roomRate,
    RoomStatus? status,
  }) {
    return Room(
      id: id,
      roomNumber: roomNumber ?? this.roomNumber,
      floor: floor ?? this.floor,
      roomCategory: roomCategory ?? this.roomCategory,
      location: location ?? this.location,
      airConditioning: airConditioning ?? this.airConditioning,
      bathroomType: bathroomType ?? this.bathroomType,
      bedType: bedType ?? this.bedType,
      capacity: capacity ?? this.capacity,
      extraBedAvailable: extraBedAvailable ?? this.extraBedAvailable,
      extraBedCharge: extraBedCharge ?? this.extraBedCharge,
      roomRate: roomRate ?? this.roomRate,
      status: status ?? this.status,
    );
  }
}

enum ActivityType { added, statusUpdated, removed }

class ActivityEntry {
  final String id;
  final String title;

  // Original fields used by RoomData.
  final String description;
  final DateTime timestamp;

  final ActivityType type;

  ActivityEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
  });

  // Compatibility getters used by DashboardPage.
  String get subtitle => description;

  DateTime get time => timestamp;
}

class RoomData {
  RoomData._();

  static final ValueNotifier<List<Room>> rooms = ValueNotifier<List<Room>>([]);

  static final ValueNotifier<List<ActivityEntry>> activity =
      ValueNotifier<List<ActivityEntry>>([]);

  static int _idCounter = 0;

  static void addRoom({
    required String roomNumber,
    required String floor,
    required RoomCategory roomCategory,
    required String location,
    required AirConditioning airConditioning,
    required BathroomType bathroomType,
    required BedType bedType,
    required int capacity,
    required bool extraBedAvailable,
    required double extraBedCharge,
    required double roomRate,
  }) {
    final room = Room(
      id: 'room_${++_idCounter}',
      roomNumber: roomNumber,
      floor: floor,
      roomCategory: roomCategory,
      location: location,
      airConditioning: airConditioning,
      bathroomType: bathroomType,
      bedType: bedType,
      capacity: capacity,
      extraBedAvailable: extraBedAvailable,
      extraBedCharge: extraBedCharge,
      roomRate: roomRate,
      status: RoomStatus.available,
    );

    rooms.value = [...rooms.value, room];

    _logActivity(
      type: ActivityType.added,
      title: 'New room added',
      description: 'Room ${room.roomNumber} was added',
    );
  }

  static void updateRoom({
    required String id,
    required String roomNumber,
    required String floor,
    required RoomCategory roomCategory,
    required String location,
    required AirConditioning airConditioning,
    required BathroomType bathroomType,
    required BedType bedType,
    required int capacity,
    required bool extraBedAvailable,
    required double extraBedCharge,
    required double roomRate,
  }) {
    final index = rooms.value.indexWhere((room) => room.id == id);

    if (index == -1) {
      return;
    }

    final existingRoom = rooms.value[index];

    final updatedRoom = existingRoom.copyWith(
      roomNumber: roomNumber,
      floor: floor,
      roomCategory: roomCategory,
      location: location,
      airConditioning: airConditioning,
      bathroomType: bathroomType,
      bedType: bedType,
      capacity: capacity,
      extraBedAvailable: extraBedAvailable,
      extraBedCharge: extraBedCharge,
      roomRate: roomRate,
    );

    final updatedRooms = [...rooms.value];

    updatedRooms[index] = updatedRoom;

    rooms.value = updatedRooms;

    _logActivity(
      type: ActivityType.added,
      title: 'Room updated',
      description: 'Room ${updatedRoom.roomNumber} was updated',
    );
  }

  static void updateStatus(String id, RoomStatus status) {
    final index = rooms.value.indexWhere((room) => room.id == id);

    if (index == -1) {
      return;
    }

    final room = rooms.value[index];

    final updatedRoom = room.copyWith(status: status);

    final updatedRooms = [...rooms.value];

    updatedRooms[index] = updatedRoom;

    rooms.value = updatedRooms;

    _logActivity(
      type: ActivityType.statusUpdated,
      title: 'Room status updated',
      description: 'Room ${room.roomNumber} is now ${status.label}',
    );
  }

  static void deleteRoom(String id) {
    final roomIndex = rooms.value.indexWhere((room) => room.id == id);

    if (roomIndex == -1) {
      return;
    }

    final room = rooms.value[roomIndex];

    rooms.value = rooms.value.where((room) => room.id != id).toList();

    _logActivity(
      type: ActivityType.removed,
      title: 'Room removed',
      description: 'Room ${room.roomNumber} was removed',
    );
  }

  static void _logActivity({
    required ActivityType type,
    required String title,
    required String description,
  }) {
    final entry = ActivityEntry(
      id: 'activity_${DateTime.now().microsecondsSinceEpoch}',
      type: type,
      title: title,
      description: description,
      timestamp: DateTime.now(),
    );

    final updatedActivity = [entry, ...activity.value];

    activity.value = updatedActivity.take(20).toList();
  }
}
