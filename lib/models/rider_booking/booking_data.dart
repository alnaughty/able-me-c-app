import 'dart:convert';

import 'package:able_me/models/rider_booking/instruction.dart';
import 'package:able_me/services/api/booking/transportation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingPayload {
  static final TransportationApi _bookApi = TransportationApi();
  final int? riderID; //OPTIONAL since we can post booking
  final int userID, type, transpoType, passengers, luggage;
  final TimeOfDay departureTime;
  final DateTime departureDate;
  final double price;
  final String? note;
  final bool isWheelchairFriendly, withPet;
  final GeoPoint? destination;
  final GeoPoint pickupLocation;

  const BookingPayload(
      {this.riderID,
      required this.userID,
      required this.type,
      required this.transpoType,
      required this.passengers,
      required this.luggage,
      required this.departureTime,
      required this.departureDate,
      required this.destination,
      required this.pickupLocation,
      required this.price,
      required this.isWheelchairFriendly,
      this.note,
      required this.withPet});
  Future<bool> book() async => await _bookApi.book(payload: this);

  BookingPayload copyWith({
    int? type,
    int? transpoType,
    int? passengers,
    int? luggage,
    int? userID,
    TimeOfDay? departureTime,
    DateTime? departureDate,
    GeoPoint? destination,
    GeoPoint? pickupLocation,
    double? price,
    bool? isWheelchairFriendly,
    bool? withPet,
    String? note,
    int? riderID,
  }) =>
      BookingPayload(
          riderID: riderID ?? this.riderID,
          userID: userID ?? this.userID,
          type: type ?? this.type,
          transpoType: transpoType ?? this.transpoType,
          passengers: passengers ?? this.passengers,
          luggage: luggage ?? this.luggage,
          departureTime: departureTime ?? this.departureTime,
          departureDate: departureDate ?? this.departureDate,
          destination: destination ?? this.destination,
          pickupLocation: pickupLocation ?? this.pickupLocation,
          price: price ?? this.price,
          isWheelchairFriendly:
              isWheelchairFriendly ?? this.isWheelchairFriendly,
          note: note ?? this.note,
          withPet: withPet ?? this.withPet);

  Map<String, dynamic> toJson() => {
        "customer_id": "$userID",
        "type": "$type",
        "price": "$price",
        "transportation_type": "$transpoType",
        "destination": destination == null
            ? null
            : "${destination!.latitude},${destination!.longitude}",
        "pickup_location": pickupLocation == null
            ? null
            : '${pickupLocation!.latitude},${pickupLocation!.longitude}',
        "passengers": "$passengers",
        "luggages": "$luggage",
        "is_wheelchair_friendly": "${isWheelchairFriendly ? 1 : 0}",
        "departure_date": DateFormat('yyyy-MM-dd').format(departureDate),
        "departure_time": "${departureTime.hour}:${departureTime.minute}",
        "with_pet_companion": "${withPet ? 1 : 0}",
      };
  Map<String, dynamic> toPayload() {
    final Map<String, dynamic> f = toJson();
    if (riderID != null) {
      f.addAll({'rider_id': "$riderID"});
    }
    if (note != null) {
      f.addAll({'note': note});
    }
    return f;
  }

  toPayload2() => json.encode(toPayload());
}
