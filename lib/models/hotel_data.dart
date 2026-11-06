import 'package:flutter/foundation.dart';

class HotelInfo {
  final String name;
  final String type;
  final String contact;
  final String email;
  final String address;
  final String location;

  const HotelInfo({
    this.name = '',
    this.type = '',
    this.contact = '',
    this.email = '',
    this.address = '',
    this.location = '',
  });

  bool get isEmpty =>
      name.trim().isEmpty &&
      type.trim().isEmpty &&
      contact.trim().isEmpty &&
      email.trim().isEmpty &&
      address.trim().isEmpty &&
      location.trim().isEmpty;

  HotelInfo copyWith({
    String? name,
    String? type,
    String? contact,
    String? email,
    String? address,
    String? location,
  }) {
    return HotelInfo(
      name: name ?? this.name,
      type: type ?? this.type,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      address: address ?? this.address,
      location: location ?? this.location,
    );
  }
}

class HotelData {
  HotelData._();

  static final ValueNotifier<HotelInfo> notifier = ValueNotifier<HotelInfo>(
    const HotelInfo(),
  );
}
