import 'package:able_me/models/rider_booking/booking_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class BookingPayloadVM {
  BookingPayloadVM._pr();
  static final BookingPayloadVM _instance = BookingPayloadVM._pr();
  static BookingPayloadVM get instance => _instance;
  static final BookingPayload _default = BookingPayload(
    userID: 0,
    type: 5,
    transpoType: 2,
    passengers: 1,
    luggage: 0,
    departureTime: TimeOfDay.now(),
    departureDate: DateTime.now(),
    destination: null,
    pickupLocation: const GeoPoint(0, 0),
    price: 0.0,
    isWheelchairFriendly: true,
    withPet: false,
  );

  final BehaviorSubject<BookingPayload> _subject =
      BehaviorSubject<BookingPayload>.seeded(_default);
  Stream<BookingPayload> get stream => _subject.stream;
  BookingPayload get value => _subject.value;

  updateRiderID(int id) {
    _subject.add(value.copyWith(riderID: id));
  }

  updateType(int type) {
    _subject.add(value.copyWith(type: type));
  }

  updateTranspoType(int transpoType) {
    _subject.add(value.copyWith(transpoType: transpoType));
  }

  updateDepartureTime(TimeOfDay f) {
    _subject.add(value.copyWith(departureTime: f));
  }

  updateDepartureDate(DateTime d) {
    _subject.add(value.copyWith(departureDate: d));
  }

  updatePrice(double f) {
    _subject.add(value.copyWith(price: f));
  }

  updateWithPet(bool s) {
    _subject.add(value.copyWith(withPet: s));
  }

  updateWheelChair(bool f) {
    _subject.add(value.copyWith(isWheelchairFriendly: f));
  }

  updateID(int id) {
    _subject.add(value.copyWith(userID: id));
  }

  updateDestination(GeoPoint p) {
    _subject.add(value.copyWith(destination: p));
  }

  updatePickupLocation(GeoPoint p) {
    _subject.add(value.copyWith(pickupLocation: p));
  }

  updateLuggage(int d) {
    _subject.add(value.copyWith(luggage: d));
  }

  updatePassenger(int p) {
    _subject.add(value.copyWith(passengers: p));
  }

  updateNote(String note) {
    _subject.add(value.copyWith(note: note));
  }

  reset() {
    _subject.add(_default);
  }
}
