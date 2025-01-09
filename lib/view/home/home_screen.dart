import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_kick/controllers/auth_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    AuthController _authController = AuthController();

    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              _authController.signOutUser(context: context, ref: ref);
            },
            child: Text("Signout")),
      ),
    );
  }
}
