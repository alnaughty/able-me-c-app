import 'package:able_me/models/firebase_user_location_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserLocationStateNotifier
    extends StateNotifier<List<FirebaseUserLocation>> {
  UserLocationStateNotifier(super.state);

  void update(List<FirebaseUserLocation> data) {
    state = data;
  }

  void append(FirebaseUserLocation data) {
    state = [...state, data];
  }
}

final userLocationProvider = StateNotifierProvider<UserLocationStateNotifier,
    List<FirebaseUserLocation>>(
  (ref) => UserLocationStateNotifier([]),
);
