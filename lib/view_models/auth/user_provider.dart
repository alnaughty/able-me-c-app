import 'package:able_me/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CurrentUser extends StateNotifier<UserModel?> {
//   CurrentUser() : super(null);
//   void update(UserModel model) {
//     state = model;
//   }
// }

final currentUser = StateProvider<UserModel?>(
  (ref) => null,
);

final accessTokenProvider = StateProvider<String?>((ref) => null);
final notificationProvider = StateProvider<String?>((ref) => null);
