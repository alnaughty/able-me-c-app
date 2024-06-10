import 'package:flutter/material.dart';

class TransportationDetails {
  final int id, bookingId, passengers, luggages, type;
  final DateTime departureDate;
  final TimeOfDay departureTime;
  const TransportationDetails({
    required this.bookingId,
    required this.id,
    required this.passengers,
    required this.luggages,
    required this.type,
    required this.departureDate,
    required this.departureTime,
  });

  factory TransportationDetails.fromJson(Map<String, dynamic> json) {
    final List<int> timeVal = json['departure_time']
        .toString()
        .split(":")
        .map((e) => int.parse(e))
        .toList();
    return TransportationDetails(
      bookingId: json["booking_id"],
      id: json['id'],
      passengers: json['passengers'],
      luggages: json['luggages'],
      type: json['type'],
      departureDate: DateTime.parse(json['departure_date']),
      departureTime: TimeOfDay(hour: timeVal.first, minute: timeVal[1]),
    );
  }
}
