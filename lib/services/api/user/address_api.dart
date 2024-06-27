import 'dart:convert';
import 'dart:io';

import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/profile/user_address.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/services/app_src/network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AddressApi extends Network {
  static final DataCacher _cacher = DataCacher.instance;
  final String? _accessToken = _cacher.getUserToken();
  Future<int?> add({
    required String address,
    required String locality,
    required String city,
    required String country,
    required GeoPoint coordinates,
    required String title,
  }) async {
    try {
      return await http.post("${endpoint}client/address/add".toUri, headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_accessToken"
      }, body: {
        "title": title,
        "city": city,
        "country": country,
        "address": address,
        "coordinates": "${coordinates.latitude},${coordinates.longitude}",
        "state": locality,
      }).then((response) {
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          print(data);
          return data['result']['id'];
        }

        return null;
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool> remove({required int id}) async {
    try {
      return await http.delete(
        "${endpoint}client/address/$id/delete".toUri,
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $_accessToken"
        },
      ).then((response) => response.statusCode == 200);
    } catch (e) {
      return false;
    }
  }

  Future<List<UserAddress>> get() async {
    try {
      assert(_accessToken != null, "NO ACCESSTOKEN FOUND!");
      return await http.get("${endpoint}address/search".toUri, headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_accessToken"
      }).then((response) {
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          final List res = data['data'];
          //

          return res.map((e) => UserAddress.fromJson(e)).toList();
        }
        return [];
      });
    } catch (e) {
      return [];
    }
  }
}
