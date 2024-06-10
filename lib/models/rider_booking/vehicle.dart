class Vehicle {
  final int id, userId, seats;
  final String plateNumber, carModel, carBrand, type;
  final double fare;

  const Vehicle({
    required this.id,
    required this.userId,
    required this.seats,
    required this.plateNumber,
    required this.carModel,
    required this.carBrand,
    required this.fare,
    required this.type,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json['id'],
        userId: json['user_id'],
        seats: json['seats'],
        plateNumber: json['plate_number'],
        carModel: json['car_model'],
        carBrand: json['car_brand'],
        fare: json['fare'] ?? 0.0,
        type: json['type'],
      );
}
