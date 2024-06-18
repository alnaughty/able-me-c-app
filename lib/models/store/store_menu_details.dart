import 'package:able_me/models/store/store_menu.dart';
import 'package:able_me/models/store/store_model.dart';

class StoreMenuDetails extends StoreMenu {
  final StoreModel store;
  final int ratingCount;
  final List<String> photos;
  final List<StoreMenu> suggestions;
  StoreMenuDetails({
    required super.id,
    required super.name,
    required super.desc,
    required super.photoUrl,
    required super.isPopular,
    required super.isAvailable,
    required super.price,
    required this.store,
    required this.ratingCount,
    required this.photos,
    required this.suggestions,
  });
  factory StoreMenuDetails.fromJson(Map<String, dynamic> json, List s) {
    final List p = json['photos'] ?? [];
    // final List s = json['suggestions'] ?? [];
    return StoreMenuDetails(
      id: json['id'],
      name: json['name'],
      desc: json['description'],
      photoUrl: json['photo_url'],
      isPopular: json['is_popular'] == 1,
      isAvailable: json['is_available'] == 1,
      price: double.parse(json['price'].toString()),
      ratingCount: json['rating'] ?? 0,
      suggestions: s
          .map((e) => StoreMenu.fromJson(e))
          .toList()
          .where((element) => element.id != json['id'])
          .toList(),
      photos: p.map((e) => e['image'].toString()).toList(),
      store: StoreModel.fromJson(json['store']),
    );
  }
}
