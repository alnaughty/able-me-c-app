import 'dart:convert';
import 'dart:io';

import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/blogs/blog_details.dart';
import 'package:able_me/models/blogs/blog_model.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/services/app_src/network.dart';
import 'package:http/http.dart' as http;

class BlogApi extends Network {
  static final DataCacher _cacher = DataCacher.instance;
  final String? accessToken = _cacher.getUserToken();

  Future<BlogDetails?> getDetails(int id) async {
    try {
      return await http.get("${endpoint}blog/$id/details".toUri, headers: {
        "Accepts": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      }).then((response) {
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          return BlogDetails.fromJson(data['blog']);
        }
        return null;
      });
    } catch (h) {
      return null;
    }
  }

  Future<List<BlogModel>> getList() async {
    try {
      return await http.get("${endpoint}blog/search".toUri, headers: {
        "Accepts": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      }).then((response) {
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          final List res = data['data'];
          return res
              .where((e) => e['is_publish'] == 1)
              .map((e) => BlogModel.fromJson(e))
              .toList();
        }
        return [];
      });
    } catch (e) {
      return [];
    }
  }
}
