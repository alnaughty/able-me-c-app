import 'package:able_me/models/blogs/blog_category.dart';
import 'package:able_me/models/blogs/blog_model.dart';

class BlogDetails extends BlogModel {
  final String author, body;
  final List<String> images;

  const BlogDetails({
    required super.id,
    required super.likes,
    required super.views,
    required super.title,
    required super.comments,
    required super.category,
    required super.publishedOn,
    required this.author,
    required this.body,
    required super.featuredPhoto,
    required this.images,
  });
  factory BlogDetails.fromJson(Map<String, dynamic> json) {
    final List imgs = json['photos'];
    return BlogDetails(
      id: json['id'],
      featuredPhoto: json['image_url'],
      likes: json['likes_count'] ?? 0,
      views: json['views_count'] ?? 0,
      title: json['title'],
      category: BlogCategory.fromJson(json['category']),
      comments: json['comments_count'] ?? 0,
      publishedOn: DateTime.parse(json['publish_date']),
      author: json['author'],
      body: json['body'],
      images: imgs.map((e) => e['image'].toString()).toList(),
    );
  }
}
