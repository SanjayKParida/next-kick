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

  //RECREATE USER STATE
  void recreateUserState({
    required String state,
    required String city,
    required String locality,
  }) {
    if (this.state != null) {
      this.state = UserModel(
        //PRESERVE EXISTING ID, FULLNAME, EMAIL, PASSWORD & TOKEN
        id: this.state!.id,
        fullName: this.state!.fullName,
        email: this.state!.email,
        password: this.state!.password,
        token: this.state!.token,
      );
    }
  }
}

final userProvider = StateNotifierProvider<UserProvider, UserModel?>(
  (ref) => UserProvider(),
);
