import 'package:shared_preferences/shared_preferences.dart';

class DataCacher {
  DataCacher._pr();
  static final DataCacher _instance = DataCacher._pr();
  static DataCacher get instance => _instance;
  late final SharedPreferences _prefs;
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //*
  //0 = credentials
  //1 = google
  //2 = fb
  //*/
  Future<void> signInMethod(int i) async => await _prefs.setInt(
        "sign-in-method",
        i,
      );
  int? getSignInMethod() => _prefs.getInt("sign-in-method");

  /*
  Firebase Token preparation to revoke from backend
   */
  Future<void> saveFcmToken(String tok) async {
    await _prefs.setString("fcm-token", tok);
  }

  Future<void> removeFcmToken() async => await _prefs.remove('fcm-token');
  String? getFcmToken() => _prefs.getString('fcm-token');

  /*
  User Access Token handler for easy login
   */
  String? getUserToken() => _prefs.getString("access-token");
  Future<void> setUserToken(String token) async {
    await _prefs.setString("access-token", token);
  }

  Future<void> removeToken() async => await _prefs.remove("access-token");
}
