import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/leaderboard_model.dart';
import '../services/leaderboard_service.dart';

final leaderboardServiceProvider = Provider<LeaderboardService>((ref) {
  return LeaderboardService();
});

// State notifier for leaderboard data
class LeaderboardNotifier
    extends StateNotifier<AsyncValue<List<LeaderboardModel>>> {
  final LeaderboardService _service;

  LeaderboardNotifier(this._service) : super(const AsyncValue.loading()) {
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    try {
      state = const AsyncValue.loading();
      final leaderboardData = await _service.getLeaderboard();
      state = AsyncValue.data(leaderboardData);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Provider for leaderboard state
final leaderboardProvider = StateNotifierProvider<LeaderboardNotifier,
    AsyncValue<List<LeaderboardModel>>>((ref) {
  final service = ref.watch(leaderboardServiceProvider);
  return LeaderboardNotifier(service);
});

// Provider for user rank
final userRankProvider =
    FutureProvider.family<UserRankResponse, String>((ref, userId) async {
  final service = ref.watch(leaderboardServiceProvider);
  return service.getUserRank(userId);
});
