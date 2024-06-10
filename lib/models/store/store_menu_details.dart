import 'package:able_me/models/store/store_menu.dart';
import 'package:able_me/models/store/store_model.dart';

class StoreMenuDetails extends StoreMenu {
  final StoreModel store;
  final int ratingCount;
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
  });
  factory StoreMenuDetails.fromJson(Map<String, dynamic> json) {
    return StoreMenuDetails(
      id: json['id'],
      name: json['name'],
      desc: json['description'],
      photoUrl: json['photo_url'],
      isPopular: json['is_popular'] == 1,
      isAvailable: json['is_available'] == 1,
      price: double.parse(json['price'].toString()),
      ratingCount: json['rating'] ?? 0,
      store: StoreModel.fromJson(json['store']),
    );
  }
}
