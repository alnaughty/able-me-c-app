import 'dart:convert';

import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/book_rider_details.dart';
import 'package:able_me/services/app_src/network.dart';
import 'package:http/http.dart' as http;

class RiderApi with Network {
  Future<BookRiderDetails?> getDetails(int riderID) async {
    try {
      return await http
          .get("${endpoint}rider/$riderID/details".toUri, headers: {
        "Accept": "application/json",
      }).then((response) {
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          //

          return BookRiderDetails.fromJson(data);
        }
        return null;
      });
    } catch (e) {
      return null;
    }
  }
}
