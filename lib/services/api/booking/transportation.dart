import 'dart:convert';
import 'dart:io';

import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/rider_booking/booking_data.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/services/app_src/network.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class TransportationApi with Network {
  static final DataCacher _cacher = DataCacher.instance;
  final String? accessToken = _cacher.getUserToken();
  Future<bool> book({
    required BookingPayload payload,
  }) async {
    try {
      //
      // assert(accessToken == null, "Token is null");
      //
      return await http
          .post(
        "${endpoint}booking/transportation/new".toUri,
        headers: {
          "Accepts": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accessToken"
        },
        body: payload.toPayload(),
      )
          .then((response) {
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: "Booking Uploaded");
          return true;
        }
        print(response.statusCode);
        print(response.reasonPhrase);
        print(payload.toPayload());
        Fluttertoast.showToast(
            msg: "Booking failed to upload : ${response.reasonPhrase}");
        return false;
      });
    } catch (e, s) {
      Fluttertoast.showToast(msg: "Booking failed to upload");

      return false;
    }
  }
}
