import 'dart:async';
import 'dart:io';

import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

mixin class AppleAuth {
  final List<AppleIDAuthorizationScopes> _scopes = [
    AppleIDAuthorizationScopes.email,
    AppleIDAuthorizationScopes.fullName,
  ];
  final DataCacher _cacher = DataCacher.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  Future<AuthorizationCredentialAppleID?> get credential async {
    try {
      final AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
        scopes: _scopes,
      );
      return credential;
    } catch (e) {
      return null;
    }
  }

  Future firebaseSignOut() async {
    // await _fbauth.logOut();
    await auth.signOut();
  }

  Future<User?> appleSignIn() async {
    try {
      final AuthorizationCredentialAppleID? result = await credential;
      if (result != null) {
        print("RESULT STATE : ${result.state}");
        final oAuthProvider = OAuthProvider("apple.com");

        final credential = oAuthProvider.credential(
          idToken: result.identityToken,
          accessToken: result.authorizationCode,
        );
        final authResult = await auth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        await _cacher.signInMethod(3);
        return firebaseUser;
      } else {
        Fluttertoast.showToast(msg: "An error occurred while signing in");
        return null;
      }
      // switch (result.status) {
      //   case AuthorizationStatus.authorized:
      //     final appleIdCredential = result.credential;
      //     final oAuthProvider = OAuthProvider("apple.com");

      //     final credential = oAuthProvider.credential(
      //       idToken: String.fromCharCodes(
      //           appleIdCredential?.identityToken as Iterable<int>),
      //       accessToken: String.fromCharCodes(
      //           appleIdCredential?.authorizationCode as Iterable<int>),
      //     );
      //     final authResult = await auth.signInWithCredential(credential);
      //     final firebaseUser = authResult.user;

      //     return firebaseUser;
      //   case AuthorizationStatus.error:
      //     Fluttertoast.showToast(msg: "${result.error}");
      //     return null;
      //   case AuthorizationStatus.cancelled:
      //     Fluttertoast.showToast(msg: "Sign in cancelled");
      //     return null;
      //   default:
      //     return null;
      // }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "User not found");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Incorrect Password");
      }
      return null;
    } on SocketException {
      Fluttertoast.showToast(msg: "No Internet Connection");
      return null;
    } on HttpException {
      Fluttertoast.showToast(
          msg: "An error occurred while trying to connect to server");
      return null;
    } on FormatException {
      Fluttertoast.showToast(msg: "Format Error");
      return null;
    } on TimeoutException {
      Fluttertoast.showToast(msg: "No Internet Connection : Timeout");
      return null;
    }
  }
}
