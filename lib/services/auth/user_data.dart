import 'dart:convert';
import 'dart:io';

import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/app_src/network.dart';
import 'package:http/http.dart' as http;

class UserDataApi extends Network {
  Future<UserModel?> getUserDetails(String accessToken) async {
    try {
      return http.get("${endpoint}auth/current-user".toUri, headers: {
        "Accepts": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      }).then((response) {
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return UserModel.fromJson(data);
        }
        return null;
      });
    } catch (e) {
      return null;
    }
  }
}
// return http.post("${endpoint}auth/login".toUri,
//           body: {"firebase_token": firebaseToken}).then((response) {
//         if (response.statusCode == 200) {
//           final Map<String, dynamic> data = json.decode(response.body);
//           return data['tokenResult']['accessToken'];
//         } else if (response.statusCode == 404) {
//           print(response.body);
//           Fluttertoast.showToast(msg: "Token expired, please relogin");
//           return null;
//         }
//         return null;
//       });