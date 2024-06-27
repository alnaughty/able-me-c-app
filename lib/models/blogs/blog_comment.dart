class BlogComment {
  final int id, blogID, type;
  final String comment;
  const BlogComment({
    required this.blogID,
    required this.id,
    required this.comment,
    required this.type,
  });
}
