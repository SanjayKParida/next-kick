import 'drill_model.dart';

class UserDrill {
  final String id;
  final String userId;
  final DrillModel drill;
  final int completedCount;
  final DateTime timestamp;

  UserDrill({
    required this.id,
    required this.userId,
    required this.drill,
    required this.completedCount,
    required this.timestamp,
  });

  factory UserDrill.fromJson(Map<String, dynamic> json) {
    try {
      // Handle ObjectId format from MongoDB
      String id = json['_id'] is Map
          ? json['_id']['\$oid'] ?? json['_id'].toString()
          : json['_id'].toString();
      String userId = json['userId'] is Map
          ? json['userId']['\$oid'] ?? json['userId'].toString()
          : json['userId'].toString();

      // Handle drill data
      Map<String, dynamic> drillData = json['drillId'] ?? json['drill'] ?? {};
      if (drillData is String) {
        // If drillId is just a string (ObjectId), we need to fetch the drill details
        // For now, create a placeholder drill
        drillData = {
          '_id': drillData,
          'name': 'Loading...',
          'totalCount': 0,
          'imageUrl': '',
          'description': ''
        };
      }

      return UserDrill(
        id: id,
        userId: userId,
        drill: DrillModel.fromJson(drillData),
        completedCount: json['completedCount'] ?? 0,
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'])
            : DateTime.now(),
      );
    } catch (e) {
      print('Error parsing UserDrill JSON: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }
}
