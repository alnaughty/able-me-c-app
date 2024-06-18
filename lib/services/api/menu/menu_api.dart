import 'dart:convert';
import 'dart:io';

import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/store/store_menu_details.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/services/app_src/network.dart';
import 'package:http/http.dart' as http;

class MenuApi extends Network {
  static final DataCacher _cacher = DataCacher.instance;
  final String? accessToken = _cacher.getUserToken();
  Future<StoreMenuDetails?> getDetails(int id) async {
    try {
      return await http.get("${endpoint}menuitems/$id/details".toUri, headers: {
        "Accepts": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      }).then((response) {
        if (response.statusCode == 200) {
          var res = json.decode(response.body);

          return StoreMenuDetails.fromJson(res['result'], res['suggestions']);
        }
        print("ERROR DETAILS SERVER FETCH");
        return null;
      });
    } catch (e) {
      print("MENU DETAILS ERROR: $e");
      return null;
    }
  }
}
