import 'package:flutter/foundation.dart';

@immutable
class Store {
  final int id;
  final String name; // mağaza adı
  final String latitude; // enlem
  final String longitude; // boylam
  final String address;
  double distance;

  Store(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.address,
      this.distance = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  @override
  String toString() {
    return 'Store{id: $id, name: $name, latitude: $latitude, longitude: $longitude, address: $address}';
  }
}
