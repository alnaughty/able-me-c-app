import 'package:able_me/models/store/category.dart';
import 'package:able_me/models/store/store_menu.dart';
import 'package:able_me/models/store/store_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreDetails extends StoreModel {
  final List<StoreMenu> menu;
  final List<Category> categories;
  final GeoPoint coordinates;
  StoreDetails({
    required super.id,
    required super.type,
    required super.name,
    required super.desc,
    required super.photoUrl,
    required super.coverUrl,
    required super.country,
    required super.ratingCount,
    required super.state,
    required super.region,
    required this.menu,
    required this.categories,
    required this.coordinates,
  });
  factory StoreDetails.fromJson(Map<String, dynamic> json) {
    final StoreType _type =
        json['type'] == 1 ? StoreType.restaurant : StoreType.pharmacy;
    final List menus = json['menu_items'];
    final List _cats = json['categories'];
    final List<double> _coord = json['coordinates']
        .toString()
        .split(",")
        .map((e) => double.parse(e))
        .toList();
    return StoreDetails(
      id: json['id'],
      type: _type,
      name: json['name'],
      desc: json['description'],
      photoUrl: json['photo_url'],
      coverUrl: json['cover_url'],
      country: json['country'],
      state: json['state'],
      region: json['region'],
      coordinates: GeoPoint(_coord.first, _coord.last),
      ratingCount: json['rating_count'] ?? 0,
      menu: menus.map((e) => StoreMenu.fromJson(e)).toList(),
      categories: _cats.map((e) => Category.fromJson(e)).toList(),
    );
  }
}
