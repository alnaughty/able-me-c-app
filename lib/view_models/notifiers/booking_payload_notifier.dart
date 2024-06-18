// import 'package:able_me/helpers/geo_point_ext.dart';
// import 'package:able_me/models/rider_booking/booking_data.dart';
// import 'package:able_me/models/user_model.dart';
// import 'package:able_me/view_models/app/coordinate.dart';
// import 'package:able_me/view_models/auth/user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geolocator/geolocator.dart';

// // final bookingPayloadNotifier = StateProvider<BookingPayload>((ref) {
// //   final UserModel? u = ref.watch(currentUser);
// //   if (u == null) {
// //     throw "No user found!";
// //   }
// //   final Position? pos = ref.watch(coordinateProvider);
// //   if (pos == null) {
// //     throw "No positioning!";
// //   }
// //   return BookingPayload(
// //     userID: u.id,
// //     type: 5,
// //     transpoType: 2,
// //     passengers: 1,
// //     luggage: 0,
// //     departureTime: TimeOfDay.now(),
// //     departureDate: DateTime.now(),
// //     destination: null,
// //     pickupLocation: pos.toGeoPoint(),
// //     price: 0.0,
// //     isWheelchairFriendly: true,
// //     withPet: false,
// //   );
// // });
// final bookingPayloadNotifier =
//     StateNotifierProvider<BookingPayloadNotifier, BookingPayload>((ref) {
//   final UserModel? u = ref.watch(currentUser);
//   if (u == null) {
//     throw "No user found!";
//   }
//   final Position? pos = ref.watch(coordinateProvider);
//   if (pos == null) {
//     throw "No positioning!";
//   }
//   return BookingPayloadNotifier(
//     BookingPayload(
//       userID: u.id,
//       type: 5,
//       transpoType: 2,
//       passengers: 1,
//       luggage: 0,
//       departureTime: TimeOfDay.now(),
//       departureDate: DateTime.now(),
//       destination: null,
//       pickupLocation: pos.toGeoPoint(),
//       price: 0.0,
//       isWheelchairFriendly: true,
//       withPet: false,
//     ),
//   );
// });

// class BookingPayloadNotifier extends StateNotifier<BookingPayload> {
//   BookingPayloadNotifier(super.state);

//   void updatePassengers(int passengers) {
//     state = state.copyWith(passengers: passengers);
//   }

//   void updateLuggage(int luggage) {
//     state = state.copyWith(luggage: luggage);
//   }
// }
