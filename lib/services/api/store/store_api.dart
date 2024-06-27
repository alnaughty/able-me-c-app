import 'dart:convert';
import 'dart:io';

import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/store/store_details.dart';
import 'package:able_me/models/store/store_model.dart';
import 'package:able_me/models/store/store_params.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/services/app_src/network.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';

class StoreAPI with Network {
  static final DataCacher _cacher = DataCacher.instance;
  final String? accessToken = _cacher.getUserToken();
//   final storeListing =
//     FutureProvider.family<List<StoreModel>, StoreParams>((ref, params) {
//   return ref
//       .watch(storeApiProvider)
//       .getStore();
// });
  Future<StoreDetails?> getDetails(int id) async {
    try {
      print(id);
      return await http.get("${endpoint}store/$id/details".toUri, headers: {
        "Accepts": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      }).then((response) {
        if (response.statusCode == 200) {
          var da = json.decode(response.body);
          return StoreDetails.fromJson(da['result']);
        }
        return null;
      });
    } catch (e) {
      return null;
    }
  }

  Future<List<StoreModel>> getStore({StoreParams? params}) async {
    try {
      return await http.get(
          // "${endpoint}store/search?sort_by=id/desc&type=&keyword=mang&page=1"
          "${endpoint}store/search?sort_by=id/desc&type=${params?.type ?? ""}&keyword=${params?.keyword ?? ""}"
              .toUri,
          headers: {
            "Accepts": "application/json",
            HttpHeaders.authorizationHeader: "Bearer $accessToken"
          }).then((response) {
        if (response.statusCode == 200) {
          final d = json.decode(response.body);
          final List result = d['data'];

          return result.map((e) => StoreModel.fromJson(e)).toList();
        }

        return [];
      });
    } catch (e, s) {
      return [];
    }
  }
}
