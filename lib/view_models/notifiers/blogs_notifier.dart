import 'package:able_me/models/blogs/blog_model.dart';
import 'package:able_me/services/api/blogs/blog_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _apiProvider = Provider<BlogApi>((ref) => BlogApi());
final blogListingProvider =
    FutureProvider<List<BlogModel>>((ref) => ref.read(_apiProvider).getList());
