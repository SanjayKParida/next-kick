// lib/screens/leaderboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/leaderboard_controller.dart';
import '../../models/leaderboard_model.dart';
import '../widgets/leaderboard_tile.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardState = ref.watch(leaderboardProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Leaderboard',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4527A0),
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF4527A0)),
            onPressed: () {
              ref.read(leaderboardProvider.notifier).fetchLeaderboard();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ),
      ),
      body: leaderboardState.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4527A0)),
              ),
              SizedBox(height: 16),
              Text(
                'Loading leaderboard... 🎮',
                style: TextStyle(
                  color: Color(0xFF4527A0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFF4527A0),
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong 😕\n${error.toString()}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF4527A0)),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(leaderboardProvider.notifier).fetchLeaderboard();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4527A0),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        data: (leaderboardData) => _buildLeaderboardList(leaderboardData),
      ),
    );
  }

  Widget _buildLeaderboardList(List<LeaderboardModel> leaderboardData) {
    if (leaderboardData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No players yet! 🎮\nBe the first to join!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // The actual refresh will be handled by the provider
      },
      color: const Color(0xFF4527A0),
      child: ListView.builder(
        itemCount: leaderboardData.length + 1, // +1 for the header
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeader(leaderboardData[0]); // Top player header
          }
          final entry = leaderboardData[index - 1];
          return LeaderboardTileWidget(entry: entry, index: index - 1);
        },
      ),
    );
  }

  Widget _buildHeader(LeaderboardModel topPlayer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4527A0).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4527A0).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '👑 Champion ',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4527A0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            topPlayer.fullName,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF4527A0),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                color: Color(0xFF4527A0),
              ),
              const SizedBox(width: 8),
              Text(
                '${topPlayer.totalCount} points',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4527A0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
