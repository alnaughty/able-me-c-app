import 'package:able_me/models/blogs/blog_category.dart';

class BlogModel {
  final int id, likes, views, comments;
  final String title;
  final BlogCategory category;
  final DateTime publishedOn;
  final String? featuredPhoto;
  const BlogModel(
      {required this.id,
      required this.likes,
      required this.views,
      required this.title,
      required this.featuredPhoto,
      required this.comments,
      required this.category,
      required this.publishedOn});
  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
        id: json['id'],
        likes: json['likes_count'] ?? 0,
        featuredPhoto: json['image_url'],
        views: json['views_count'] ?? 0,
        title: json['title'],
        category: BlogCategory.fromJson(json['category']),
        comments: json['comments_count'] ?? 0,
        publishedOn: DateTime.parse(json['publish_date']),
      );
}
