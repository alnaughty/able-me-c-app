import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

mixin class GoogleAuth {
  final DataCacher _cacher = DataCacher.instance;
  static List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];
  static final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: scopes);
  Future<void> googleSignOut() async {
    await _googleSignIn.signOut();
    await auth.signOut();
    return;
  }

  Future<User?> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // final bool isAuthorized = await _googleSignIn.canAccessScopes(scopes);
        // print("IS AUTHORIZED : $isAuthorized");
        // if (!isAuthorized) return null;
        await _handleGetContact(googleUser);
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        // if (googleAuth != null) {

        // }
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final authResult = await auth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        await _cacher.signInMethod(1);
        return firebaseUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "User not found");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Incorrect Password");
      } else if (e.code == "account-exists-with-different-credential") {
        Fluttertoast.showToast(
            msg: "Account already exists with different credential");
      }
      return null;
    } on SocketException {
      Fluttertoast.showToast(msg: "No Internet Connection");
      return null;
    } on HttpException catch (e, s) {
      print("ERROR : $e");
      print("TRACE : $s");
      Fluttertoast.showToast(
          msg: "An error has occurred while processing your request.");
      return null;
    } on FormatException {
      Fluttertoast.showToast(msg: "Format Error");
      return null;
    } on TimeoutException {
      Fluttertoast.showToast(msg: "No Internet Connection : Timeout");
      return null;
    }
    // return null;
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    // setState(() {
    //   _contactText = 'Loading contact info...';
    // });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      // setState(() {
      //   _contactText = 'People API gave a ${response.statusCode} '
      //       'response. Check logs for details.';
      // });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    print("NAMED CONTACT : $namedContact");
    // setState(() {
    //   if (namedContact != null) {
    //     _contactText = 'I see you know $namedContact!';
    //   } else {
    //     _contactText = 'No contacts to display.';
    //   }
    // });
  }

  // Future<void> _handleGetContact(GoogleSignInAccount user) async {
  //   final http.Response response = await http.get(
  //     Uri.parse('https://people.googleapis.com/v1/people/me/connections'
  //         '?requestMask.includeField=person.names'),
  //     headers: await user.authHeaders,
  //   );
  //   if (response.statusCode != 200) {
  //     return;
  //   }
  // }
  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
        (dynamic name) =>
            (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }
}
