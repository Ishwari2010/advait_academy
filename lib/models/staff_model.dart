class StaffModel {
  final String id;
  final String name;
  final String category; // Teaching / Non-Teaching
  final double hourlyRate;
  final DateTime createdAt;

  StaffModel({
    required this.id,
    required this.name,
    required this.category,
    required this.hourlyRate,
    required this.createdAt,
  });

  factory StaffModel.fromMap(Map<String, dynamic> map) {
    return StaffModel(
      id: map["id"]?.toString() ?? "",
      name: map["name"] ?? "",
      category: map["category"] ?? "",
      hourlyRate: (map["hourly_rate"] ?? 0).toDouble(),
      createdAt: DateTime.parse(map["created_at"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "category": category,
      "hourly_rate": hourlyRate,
      "created_at": createdAt.toIso8601String(),
    };
  }
}
