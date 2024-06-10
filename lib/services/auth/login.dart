import 'dart:convert';

import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/services/app_src/network.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class UserAuth extends Network {
  // final currentUserProvider = StateNotifierProvider<CurrentUser, UserModel?>(
  //   (ref) => CurrentUser(),
  // );
  /*
  Request User accesstoken that is created at the backend of the app
   */
  Future<String?> signIn(String firebaseToken) async {
    try {
      return http.post("${endpoint}auth/login".toUri,
          body: {"firebase_token": firebaseToken}).then((response) {
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return data['tokenResult']['accessToken'];
        } else if (response.statusCode == 404) {
          print(response.body);
          Fluttertoast.showToast(msg: "Token expired, please relogin");
          return null;
        }
        return null;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "An unexpected error occurred while trying to authenticate");
      return null;
    }
  }

  Future<String?> register({
    required String email,
    required String password,
    required String name,
    required String lastName,
    required int accountType,
    required String firebaseToken,
  }) async {
    try {
      return http.post("${endpoint}client/register".toUri, body: {
        "firebase_token": firebaseToken,
        "account_type": "$accountType",
        "email": email,
        "password": password,
        "c_password": password,
        "name": name,
        "lastname": lastName,
      }).then((response) {
        print(response.body);
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          print("REGISTER DATA : $data");
          return data['access_token'];
        } else if (response.statusCode == 404) {
          print(response.body);
          Fluttertoast.showToast(msg: "Token expired, please relogin");
          return null;
        }
        return null;
      });
    } catch (e) {
      print("ERROR : $e");
      Fluttertoast.showToast(
          msg: "An unexpected error occurred while trying to authenticate");
      return null;
    }
  }
}
