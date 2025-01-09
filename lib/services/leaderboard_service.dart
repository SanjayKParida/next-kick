import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:next_kick/core/constants/constants.dart';

import '../models/leaderboard_model.dart';

class LeaderboardService {
  Future<List<LeaderboardModel>> getLeaderboard() async {
    try {
      final response = await http.get(
        Uri.parse('$URI/api/leaderboard'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((entry) => LeaderboardModel.fromJson(entry)).toList();
      } else {
        throw Exception('Failed to fetch leaderboard data');
      }
    } catch (e) {
      throw Exception('Error fetching leaderboard: $e');
    }
  }

  Future<UserRankResponse> getUserRank(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$URI/api/leaderboard/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return UserRankResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to fetch user rank');
      }
    } catch (e) {
      throw Exception('Error fetching user rank: $e');
    }
  }
}
