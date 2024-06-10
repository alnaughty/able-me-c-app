class StoreMenu {
  final int id;
  final String name, desc, photoUrl;
  final bool isPopular, isAvailable;
  final double price;
  const StoreMenu({
    required this.id,
    required this.name,
    required this.desc,
    required this.photoUrl,
    required this.isPopular,
    required this.isAvailable,
    required this.price,
  });
  factory StoreMenu.fromJson(Map<String, dynamic> json) => StoreMenu(
        id: json["id"],
        name: json["name"],
        desc: json["description"],
        photoUrl: json["photo_url"],
        isPopular: json["is_popular"] == 1,
        isAvailable: json['is_available'] == 1,
        price: double.parse(
          json['price'].toString(),
        ),
      );
}
