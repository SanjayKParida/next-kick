class DrillModel {
  final String id;
  final String name;
  final int totalCount;
  final String imageUrl;
  final String description;

  DrillModel({
    required this.id,
    required this.name,
    required this.totalCount,
    required this.imageUrl,
    required this.description,
  });

  factory DrillModel.fromJson(Map<String, dynamic> json) {
    return DrillModel(
      id: json['_id'],
      name: json['name'],
      totalCount: json['totalCount'],
      imageUrl: json['imageUrl'],
      description: json['description'],
    );
  }
}
