class Offer {
  final int id, userId, status;
  final DateTime createdAt, updatedAt;
  final ServiceType type;
  final String pickupLocation, destination, title;
  final double price, subtotal, vat, vatRate, total, discount;
  final bool isPostedByCustomer;
  final String? description;
  const Offer(
      {required this.id,
      required this.userId,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.type,
      required this.title,
      required this.pickupLocation,
      required this.destination,
      required this.price,
      required this.subtotal,
      required this.vat,
      required this.vatRate,
      required this.total,
      required this.discount,
      required this.isPostedByCustomer,
      required this.description});

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      discount: json['discount'] == null
          ? 0.0
          : double.parse(json['discount'].toString()),
      userId: json['user_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      type: translateIntToService(json['type'] ?? 0),
      title: json['title'],
      pickupLocation: json['pickup_location'],
      destination: json['destination'],
      price: json['price'],
      subtotal: json['subtotal'],
      vat: json['vat'],
      vatRate: json['vat_rate'],
      total: json['total'],
      isPostedByCustomer: json['posted_by_customer'] == null
          ? false
          : json['posted_by_customer'] == 1,
      description: json['description'],
    );
  }
  @override
  String toString() => "${toJson()}";
  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "type": type,
        "title": title,
        "user_id": userId,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "pickup_location": pickupLocation,
        "destination": destination,
        "price": price,
        "vat": vat,
        "vat_rate": vatRate,
        "total": total,
        "subtotal": subtotal,
        "discount": discount,
      };

  static ServiceType translateIntToService(int t) {
    switch (t) {
      case == 1:
        return ServiceType.transpo;
      case == 2:
        return ServiceType.food;
      case == 3:
        return ServiceType.medicine;
      default:
        return ServiceType.transpo;
    }
  }

  Offer copyWith(
          {String? title,
          String? pickupLocation,
          String? destination,
          int? type,
          int? status,
          double? price,
          double? total,
          double? subtotal,
          double? vat,
          double? vatRate,
          double? discount,
          String? description}) =>
      Offer(
        id: id,
        userId: userId,
        status: status ?? this.status,
        createdAt: createdAt,
        updatedAt: updatedAt,
        type: type == null ? this.type : translateIntToService(type),
        title: title ?? this.title,
        pickupLocation: pickupLocation ?? this.pickupLocation,
        destination: destination ?? this.destination,
        price: price ?? this.price,
        subtotal: subtotal ?? this.subtotal,
        vat: vat ?? this.vat,
        vatRate: vatRate ?? this.vatRate,
        total: total ?? this.total,
        discount: discount ?? this.discount,
        isPostedByCustomer: isPostedByCustomer,
        description: description ?? this.description,
      );
}

enum ServiceType { transpo, food, medicine }
