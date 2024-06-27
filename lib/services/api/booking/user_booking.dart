import 'dart:convert';
import 'dart:io';

import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/rider_booking/user_booking_classes/user_booking_transpo.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/services/app_src/network.dart';
import 'package:http/http.dart' as http;

class UserBookingApi with Network {
  static final DataCacher _cacher = DataCacher.instance;
  final String? accessToken = _cacher.getUserToken();
  Future<List<UserTransportationBooking>> get myBookings async {
    try {
      return await http.get(
        "${endpoint}booking/account-booking?sort_by=id/desc".toUri,
        headers: {
          "Accepts": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accessToken"
        },
      ).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);

          final List res = data['result']['data'];

          return res
              .where((element) => element['transportation'] != null)
              .map((e) => UserTransportationBooking.fromJson(e))
              .toList();
        }
        return [];
      });
    } catch (e, s) {
      return [];
    }
  }
}
