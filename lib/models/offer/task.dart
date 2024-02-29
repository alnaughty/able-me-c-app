class Task {
  final int id, offerId;
  final String title, description;
  final DateTime updatedAt, createdAt;
  const Task({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.title,
    required this.description,
    required this.offerId,
  });
  factory Task.fromJson(Map<String, dynamic> json) => Task(
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? "",
        offerId: json['offer_id'],
      );

  @override
  String toString() => "${toJson()}";
  Map<String, dynamic> toJson() => {
        "id": id,
        "offer_id": offerId,
        "title": title,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": createdAt.toIso8601String(),
      };
}
