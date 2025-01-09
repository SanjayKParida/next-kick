// lib/models/leaderboard_model.dart
class LeaderboardModel {
  final String userId;
  final String fullName;
  final int totalCount;
  final int drillsCompleted;
  final int rank;

  LeaderboardModel({
    required this.userId,
    required this.fullName,
    required this.totalCount,
    required this.drillsCompleted,
    required this.rank,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? 'Unknown',
      totalCount: json['totalCount'] ?? 0,
      drillsCompleted: json['drillsCompleted'] ?? 0,
      rank: json['rank'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'totalCount': totalCount,
      'drillsCompleted': drillsCompleted,
      'rank': rank,
    };
  }

  @override
  String toString() {
    return 'LeaderboardModel(userId: $userId, fullName: $fullName, totalCount: $totalCount, drillsCompleted: $drillsCompleted, rank: $rank)';
  }

  // Useful for comparing two instances
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LeaderboardModel &&
        other.userId == userId &&
        other.fullName == fullName &&
        other.totalCount == totalCount &&
        other.drillsCompleted == drillsCompleted &&
        other.rank == rank;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        fullName.hashCode ^
        totalCount.hashCode ^
        drillsCompleted.hashCode ^
        rank.hashCode;
  }

  // Create a copy of this instance with optional field updates
  LeaderboardModel copyWith({
    String? userId,
    String? fullName,
    int? totalCount,
    int? drillsCompleted,
    int? rank,
  }) {
    return LeaderboardModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      totalCount: totalCount ?? this.totalCount,
      drillsCompleted: drillsCompleted ?? this.drillsCompleted,
      rank: rank ?? this.rank,
    );
  }
}

// Request model for updating leaderboard
class LeaderboardUpdateRequest {
  final String userId;
  final int totalCount;

  LeaderboardUpdateRequest({
    required this.userId,
    required this.totalCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalCount': totalCount,
    };
  }
}

// Response model for user ranking
class UserRankResponse {
  final int rank;
  final int totalCount;
  final int drillsCompleted;

  UserRankResponse({
    required this.rank,
    required this.totalCount,
    required this.drillsCompleted,
  });

  factory UserRankResponse.fromJson(Map<String, dynamic> json) {
    return UserRankResponse(
      rank: json['rank'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      drillsCompleted: json['drillsCompleted'] ?? 0,
    );
  }
}
