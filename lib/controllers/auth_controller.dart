import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../provider/user_provider.dart';
import '../services/snackbar_service.dart';
import '../view/authentication/login_screen.dart';
import '../view/home/home_screen.dart';

class AuthController {
  Future<void> signUpUsers({
    required BuildContext context,
    required String email,
    required String fullName,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      final userData = {
        'fullName': fullName,
        'email': email,
        'password': password,
      };

      final response = await http.post(
        Uri.parse("$URI/api/signup"),
        body: jsonEncode(userData),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Access shared preferences
        final prefs = await SharedPreferences.getInstance();

        // Store user data
        if (responseData['user'] != null) {
          final userJson = jsonEncode(responseData['user']);
          await prefs.setString('user', userJson);
          ref.read(userProvider.notifier).setUser(userJson);
        }

        // Store token if present
        final token = responseData['token']?.toString();
        if (token != null) {
          await prefs.setString('auth_token', token);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );

        showSnackbar(context, "Account created successfully!");
      } else {
        throw Exception(responseData['message'] ?? 'Failed to create account');
      }
    } catch (e) {
      showSnackbar(context, e.toString());
      debugPrint("Signup Error: $e");
    }
  }

  Future<void> signInUsers({
    required BuildContext context,
    required String email,
    required WidgetRef ref,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$URI/api/signin"),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Get shared preferences instance
        final prefs = await SharedPreferences.getInstance();

        // Handle token
        final token = responseData['token']?.toString();
        if (token != null) {
          await prefs.setString('auth_token', token);
        }

        // Handle user data
        if (responseData['user'] != null) {
          final userJson = jsonEncode(responseData['user']);
          ref.read(userProvider.notifier).setUser(userJson);
          await prefs.setString('user', userJson);
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );

        showSnackbar(context, "Logged in successfully!");
      } else {
        throw Exception(responseData['message'] ?? 'Failed to login');
      }
    } catch (e) {
      showSnackbar(context, e.toString());
      debugPrint("Signin Error: $e");
    }
  }

  //SIGNOUT USERS
  Future<void> signOutUser({required context, required WidgetRef ref}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //CLEAR THE TOKEN FROM THE SHARED PREFERENCES
      prefs.remove('auth_token');
      //CLEAR THE USER FROM THE SHARED PREFERENCES
      prefs.remove('user');

      //CLEAR THE USER STATE
      ref.read(userProvider.notifier).signOut();

      //NAVIGATE BACK TO THE LOGIN SCREEN
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);

      showSnackbar(context, "Signed Out!");
    } catch (e) {
      showSnackbar(context, "Error Signing Out: $e");
    }
  }
}
