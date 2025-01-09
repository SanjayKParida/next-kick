import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:next_kick/core/constants/constants.dart';
import 'package:next_kick/models/drill_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_drill_model.dart';

class DrillService {
  // Helper method to get auth token
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<DrillModel>> getAllDrills() async {
    try {
      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$URI/api/drills'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => DrillModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load drills');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<void> saveUserDrill({
    required String userId,
    required String drillId,
    required int completedCount,
  }) async {
    try {
      final token = await _getAuthToken();

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.post(
        Uri.parse('$URI/api/user-drills'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': userId,
          'drillId': drillId,
          'completedCount': completedCount,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode != 201) {
        final errorData = json.decode(response.body);
        throw Exception(
            errorData['message'] ?? 'Failed to save drill progress');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to connect to the server');
    }
  }

  Future<DrillModel> getDrillById(String drillId) async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$URI/api/drills/$drillId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return DrillModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load drill details');
    }
  }

  // Get user's drill history
  Future<List<UserDrill>> getUserDrills(String userId) async {
    try {
      final token = await _getAuthToken();

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      print('Fetching drills for userId: $userId'); // Debug print

      final response = await http.get(
        Uri.parse('$URI/api/user-drills/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          print('API returned empty data array');
          return [];
        }

        final drills = await Future.wait(data.map((json) async {
          // If we need to fetch drill details separately
          if (json['drillId'] is String) {
            final drillDetails = await getDrillById(json['drillId']);
            json['drillId'] = jsonEncode(drillDetails);
          }
          return UserDrill.fromJson(json);
        }));

        print('Parsed UserDrills: $drills');
        return drills;
      } else {
        throw Exception('Failed to load user drills: ${response.body}');
      }
    } catch (e) {
      print('Error in getUserDrills: $e');
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
