import 'package:able_me/models/rider_booking/user_booking_classes/user_booking_transpo.dart';
import 'package:able_me/services/api/booking/user_booking.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _apiProvider = Provider<UserBookingApi>((ref) => UserBookingApi());
final userBookingHistory = FutureProvider<List<UserTransportationBooking>>(
    (ref) => ref.read(_apiProvider).myBookings);
