class BlogCategory {
  final int id;
  final String name;
  const BlogCategory({required this.id, required this.name});
  factory BlogCategory.fromJson(Map<String, dynamic> json) =>
      BlogCategory(id: json['id'], name: json['name']);
}
