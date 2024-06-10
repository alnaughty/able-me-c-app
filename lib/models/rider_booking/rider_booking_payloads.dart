import 'package:able_me/models/rider_booking/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RiderBookingPayloads {
  final String title, description;
  final double price;
  final int type;
  final GeoPoint pickupLocation, destination;
  final List<AdditionalTask> tasks;
  const RiderBookingPayloads(
      {required this.title,
      required this.description,
      required this.price,
      required this.destination,
      required this.pickupLocation,
      required this.tasks,
      required this.type});
  factory RiderBookingPayloads.fromJson(Map<String, dynamic> json) =>
      RiderBookingPayloads(
        title: json['title'],
        description: json['description'],
        price: json['price'],
        destination: json['destination'],
        pickupLocation: json['pickupLocation'],
        type: json['type'],
        tasks: json['tasks'] ?? [],
      );
  @override
  String toString() => "${toJson()}";
  Map<String, dynamic> toJson() => {
        "title": title,
        "destination": destination,
        "pickupLocation": pickupLocation,
        "description": description,
        "type": type,
        "tasks": tasks,
      };
}
