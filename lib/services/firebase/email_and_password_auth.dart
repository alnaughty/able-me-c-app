import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseEmailPasswordAuth {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  Future<User?> create(
      {required String email, required String password}) async {
    try {
      UserCredential creds = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return await signIn(email: creds.user!.email!, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "User not found");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Incorrect password");
      } else if (e.code == "email-already-in-use") {
        Fluttertoast.showToast(msg: "Email is already in use");
      } else if (e.code == "invalid-email") {
        Fluttertoast.showToast(
          msg: "Invalid email format",
          toastLength: Toast.LENGTH_LONG,
        );
      } else if (e.code == "weak-password") {
        Fluttertoast.showToast(
          msg: "Your password is weak",
        );
      }
      // Fluttertoast.showToast(
      //     msg: "Impossible de s'authentifier depuis le serveur : $e");
      return null;
    } on SocketException {
      Fluttertoast.showToast(msg: "No internet connection");
      return null;
    } on HttpException {
      Fluttertoast.showToast(
          msg: "An error has occured while processing your request");
      return null;
    } on FormatException {
      Fluttertoast.showToast(msg: "Format error");
      return null;
    } on TimeoutException {
      Fluttertoast.showToast(msg: "Connection timeout");
      return null;
    }
  }

  Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      assert(email.isNotEmpty && password.isNotEmpty, "INVALID INPUT DATA");

      final AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      final authResult = await auth.signInWithCredential(credential);
      final User? firebaseUser = authResult.user;
      // _cacher.savePassword(password);

      return firebaseUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "User not found");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Incorrect password");
      } else if (e.code == "") {}

      return null;
    } on SocketException {
      Fluttertoast.showToast(msg: "No internet connection");
      return null;
    } on HttpException {
      Fluttertoast.showToast(
          msg: "An error occured while processing your request");
      return null;
    } on FormatException catch (e) {
      Fluttertoast.showToast(msg: "Format error");
      return null;
    } on TimeoutException {
      Fluttertoast.showToast(msg: "Connection timeout");
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    try {
      return await auth.signOut();
    } on SocketException {
      Fluttertoast.showToast(msg: "No internet connection");
      return;
    } on HttpException {
      Fluttertoast.showToast(
          msg: "An unexpected error occurred while processing the request");
      return;
    } on FormatException catch (e) {
      Fluttertoast.showToast(msg: "Format error : $e");
      return;
    } on TimeoutException {
      Fluttertoast.showToast(msg: "No internet connection : timeout");
      return;
    }
  }
}
