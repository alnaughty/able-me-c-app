class StoreModel {
  final int id, ratingCount;
  final StoreType type;
  final String name, desc, photoUrl, coverUrl, state, country, region;
  const StoreModel(
      {required this.id,
      required this.type,
      required this.name,
      required this.desc,
      required this.photoUrl,
      required this.state,
      required this.country,
      required this.region,
      required this.coverUrl,
      required this.ratingCount});
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    final StoreType _type =
        json['type'] == 1 ? StoreType.restaurant : StoreType.pharmacy;
    return StoreModel(
      id: json['id'],
      type: _type,
      name: json['name'],
      desc: json['description'],
      photoUrl: json['photo_url'],
      coverUrl: json['cover_url'],
      country: json['country'],
      state: json['state'],
      region: json['region'],
      ratingCount: json['rating_count'] ?? 0,
    );
  }
}

enum StoreType { pharmacy, restaurant }
