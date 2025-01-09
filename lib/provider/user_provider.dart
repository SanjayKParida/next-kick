import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';

class UserProvider extends StateNotifier<UserModel?> {
  UserProvider() : super(null);

  UserModel? get user => state;

  void setUser(String userJson) {
    state = UserModel.fromJson(userJson);
  }

  //METHOD TO SIGN OUT USER
  void signOut() {
    state = null;
  }
}

final userProvider = StateNotifierProvider<UserProvider, UserModel?>(
  (ref) => UserProvider(),
);
