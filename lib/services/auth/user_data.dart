import 'dart:convert';
import 'dart:io';

import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/id_callback.dart';
import 'package:able_me/models/kyc_data_model.dart';
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
        print("ACCESSTOKEN : $accessToken");
        print("USER DETAILS : ${response.statusCode}");
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return UserModel.fromJson(data);
        }
        return null;
      });
    } catch (e) {
      print("USER ERR: $e");
      return null;
    }
  }

  Future<KYCDataModel?> getKYCStatus(String accessToken) async {
    try {
      return http.get("${endpoint}validation/get".toUri, headers: {
        "Accepts": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      }).then((response) {
        print("TOKEN: $accessToken");
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          print("KYC DATA FETCHED : $data");
          if (data is List) {
            return null;
          }

          return KYCDataModel.fromJson(data);
        }
        return null;
      });
    } on FormatException {
      return null;
    } catch (e) {
      return null;
    }
  }

  // Future<bool> validateIDs
  Future<bool> validateKYCSelfie(String accessToken, String selfie) async {
    try {
      return http.post("${endpoint}validation/save/selfie".toUri, headers: {
        "Accepts": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      }, body: {
        "selfie": "data:image/jpeg;base64,$selfie",
      }).then((response) {
        return response.statusCode == 200;
        // if (response.statusCode == 200) {
        //   final data = json.decode(response.body);
        //   print("KYC UPLOAD DATA : $data");
        //   return data;
        // }
        // print("DATA ${response.statusCode} ${response.body}");
        // return [];
      });
    } catch (e, s) {
      print("ERROR : $e");
      print("Stacktrace: $s");
      return false;
    }
  }

  Future<void> validateKYCIDs(String accessToken, IDCallback id) async {
    try {
      return http.post("${endpoint}validation/save".toUri, headers: {
        "Accepts": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      }, body: {
        "front": "data:image/jpeg;base64,${id.front}",
        "back": "data:image/jpeg;base64,${id.back}",
        "identification": id.type,
      }).then((response) {
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          print("KYC UPLOAD DATA : $data");
          return data;
        }
        print("DATA ${response.statusCode} ${response.body}");
        return [];
      });
    } catch (e, s) {
      print("ERROR : $e");
      print("Stacktrace: $s");
      return;
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