import 'dart:convert';
import 'dart:io';

import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/profile/kyc_status.dart';
import 'package:able_me/services/app_src/network.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class KYCService extends Network {
  Future<KYCStatus?> getKYCStatus(String accessToken) async {
    try {
      return await http.get("$endpoint/kyc".toUri, headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken",
      }).then((response) {
        print("TOKEN: $accessToken");
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          // print("KYC DATA $data");
          print("KYC DATA ${response.statusCode}: ${response.body}");
          return KYCStatus.fromJson(data);
          // final List result = data['negotiations'] as List;
          // return result.map((e) => NegotiationModel.fromJson(e)).toList();
        }
        print("KYC DATA ERROR ${response.statusCode}: ${response.body}");
        return null;
      });
    } catch (e, s) {
      print("ERROR : $e $s");
      return null;
    }
  }

  Future<bool> sendValidationCode(String accessToken,
      {required String email, required String code}) async {
    try {
      return await http
          .post("${endpoint}emailverification/verify".toUri, headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken",
      }, body: {
        "email": email,
        "code": code,
      }).then((response) {
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: "Email Validated");
          return true;
        }
        print("RESPONSE ${response.statusCode}");
        return false;
      });
    } catch (e, s) {
      print("ERRORS : $e, $s");
      return false;
    }
  }

  Future<bool> sendEmailVerificationCode(
      String accessToken, String email) async {
    try {
      return await http
          .post("${endpoint}emailverification/send-code".toUri, headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken",
      }, body: {
        "email": email,
      }).then((response) {
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: "Email verification sent");
          return true;
        }
        print("RESPONSE ${response.statusCode}");
        return false;
      });
    } catch (e, s) {
      print("ERRORS : $e, $s");
      return false;
    }
  }

  Future<void> uploadKYC(
    String accessToken, {
    required String type,
    required String selfie,
    required String idFront,
    required String idBack,
  }) async {
    try {
      return await http.post(
        "$endpoint/api/kyc".toUri,
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accessToken",
        },
        body: {
          "id_type": type,
          "selfie": "data:image/jpeg;base64,$selfie",
          "id_front": "data:image/jpeg;base64,$idFront",
          "id_back": "data:image/jpeg;base64,$idBack",
        },
      ).then((response) {
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          print("KYC UPLOAD DATA $data");
          Fluttertoast.showToast(
              msg: "Our team will review your data, Thank you!");
          // return 1;
          // final List result = data['negotiations'] as List;
          // return result.map((e) => NegotiationModel.fromJson(e)).toList();
        } else if (response.statusCode == 413) {
          Fluttertoast.showToast(msg: "Your file is too large");
        }
        print("KYC DATA ERROR ${response.statusCode}: ${response.body}");
        return null;
      });
    } catch (e, s) {
      print("ERROR : $e $s");
      return;
    }
  }
}
