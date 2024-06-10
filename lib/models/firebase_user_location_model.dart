import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserLocation {
  final String fullname, avatar;
  final Timestamp lastActive;
  final GeoPoint coordinates;
  final int id;

  const FirebaseUserLocation({
    required this.fullname,
    required this.avatar,
    required this.lastActive,
    required this.coordinates,
    required this.id,
  });
  factory FirebaseUserLocation.fromFirestore(DocumentSnapshot doc) {
    // Map<String, dynamic> json = ;
    GeoPoint geo = doc.get('location') as GeoPoint;
    return FirebaseUserLocation(
      fullname: doc.get('name'),
      avatar: doc.get('avatar'),
      lastActive: doc.get('last_active') as Timestamp,
      coordinates: geo,
      id: doc.get('id'),
    );
  }

  @override
  String toString() => "${toJson()}";
  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "fullname": fullname,
        "active": lastActive,
        "coordinates": "${coordinates.latitude} ${coordinates.longitude}",
        "id": id,
      };
}
