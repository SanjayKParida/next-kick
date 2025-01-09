import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_kick/view/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/user_provider.dart';
import 'view/authentication/login_screen.dart';

void main() {
  //RUN THE FLUTTER APP WRAPPED IN A PROVIDER SCOPE
  runApp(const ProviderScope(child: MyApp()));
}

//ROOT WIDGET OF THE APPLICATION WILL BE A CONSUMER WIDGET
//IN ORDER TO CONSUME STATE CHANGE
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  //METHOD TO CHECK THE TOKEN AND SET THE USER DATA IF AVAILABLE
  Future<void> _checkTokenAndSetUser(WidgetRef ref) async {
    //CREATING AN INSTANCE OF SHARED PREFERENCES FOR LOCAL DATA STORAGE
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //RETRIEVE THE AUTH TOKEN AND USER DATA STORED LOCALLY
    String? token = prefs.getString('auth_token');
    String? userJson = prefs.getString('user');

    //IF BOTH TOKEN AND USER DATA AVAILABLE, THEN UPDATE THE STATE
    if (token != null && userJson != null) {
      ref.read(userProvider.notifier).setUser(userJson);
    } else {
      ref.read(userProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Market Sphere',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: _checkTokenAndSetUser(ref),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final user = ref.watch(userProvider);
          return user != null ? const HomeScreen() : const LoginScreen();
        },
      ),
    );
  }
}
