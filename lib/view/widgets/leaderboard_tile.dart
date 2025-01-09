// lib/widgets/leaderboard_tile.dart
import 'package:flutter/material.dart';
import '../../models/leaderboard_model.dart';

class LeaderboardTileWidget extends StatelessWidget {
  final LeaderboardModel entry;
  final int index;

  const LeaderboardTileWidget({
    super.key,
    required this.entry,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isTopThree = index < 3;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: isTopThree ? 8 : 2,
        shadowColor: isTopThree ? _getMedalColor(index).withOpacity(0.5) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: isTopThree
              ? BorderSide(
                  color: _getMedalColor(index).withOpacity(0.5), width: 2)
              : BorderSide.none,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: isTopThree
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getBackgroundColor(index)!,
                      _getBackgroundColor(index)!.withOpacity(0.5),
                    ],
                  )
                : null,
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: _buildLeadingWidget(index),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.emoji_events,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${entry.drillsCompleted} drills completed',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${entry.totalCount}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: isTopThree ? _getMedalColor(index) : null,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '🏆',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'points',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingWidget(int index) {
    final medalEmoji = _getMedalEmoji(index);
    final backgroundColor = _getMedalColor(index);

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: backgroundColor,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            medalEmoji,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            '#${index + 1}',
            style: TextStyle(
              color: backgroundColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _getMedalEmoji(int index) {
    switch (index) {
      case 0:
        return '🥇';
      case 1:
        return '🥈';
      case 2:
        return '🥉';
      default:
        return '🎯';
    }
  }

  Color _getMedalColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFD700); // Gold
      case 1:
        return const Color(0xFFC0C0C0); // Silver
      case 2:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.blue;
    }
  }

  Color? _getBackgroundColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFF8E1); // Light Gold
      case 1:
        return const Color(0xFFF5F5F5); // Light Silver
      case 2:
        return const Color(0xFFEFEBE9); // Light Bronze
      default:
        return null;
    }
  }
}
