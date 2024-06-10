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
  final List<Instruction> additionalInstructions;
  final TimeOfDay departureTime;
  final DateTime departureDate;
  final double price;
  final String? note;
  final bool isWheelchairFriendly, withPet;
  final GeoPoint destination, pickupLocation;

  const BookingPayload(
      {this.riderID,
      required this.userID,
      required this.type,
      required this.transpoType,
      required this.passengers,
      required this.luggage,
      required this.additionalInstructions,
      required this.departureTime,
      required this.departureDate,
      required this.destination,
      required this.pickupLocation,
      required this.price,
      required this.isWheelchairFriendly,
      this.note,
      required this.withPet});
  Future<bool> book() async => _bookApi.book(payload: this);
  Map<String, dynamic> toJson() => {
        "customer_id": "$userID",
        "type": "$type",
        "price": "$price",
        "transportation_type": "$transpoType",
        "destination": "${destination.latitude},${destination.longitude}",
        "pickup_location":
            '${pickupLocation.latitude},${pickupLocation.longitude}',
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
    if (additionalInstructions.isNotEmpty) {
      for (int i = 0; i < additionalInstructions.length; i++) {
        // f.addAll({
        //   "\"instructions[$i][title]\"": additionalInstructions[i].title,
        //   "\"instructions[$i][description]\"":
        //       additionalInstructions[i].description,
        // });
        f["instructions[\"$i\"][\"title\"]"] = additionalInstructions[i].title;
        f["instructions[\"$i\"][\"description\"]"] =
            additionalInstructions[i].description;
        print(f);
      }
    }
    return f;
  }

  toPayload2() => json.encode(toPayload());
}
