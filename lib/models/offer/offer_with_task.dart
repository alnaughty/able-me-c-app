import 'package:able_me/models/offer/offer.dart';
import 'package:able_me/models/offer/task.dart';
import 'package:able_me/models/user_model.dart';

class OfferWithTask extends Offer {
  final UserModel user;
  final List<UserModel> applicants;
  final List<Task> tasks;
  OfferWithTask({
    required super.id,
    required super.userId,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required super.type,
    required super.title,
    required super.pickupLocation,
    required super.destination,
    required super.price,
    required super.subtotal,
    required super.vat,
    required super.vatRate,
    required super.total,
    required super.discount,
    required super.isPostedByCustomer,
    required super.description,
    required this.applicants,
    required this.user,
    required this.tasks,
  });

  factory OfferWithTask.fromJson(Map<String, dynamic> json) {
    final List applicantsData = json['applicants'];
    final List tasksData = json['tasks'];
    return OfferWithTask(
      id: json['id'],
      discount: json['discount'] == null
          ? 0.0
          : double.parse(json['discount'].toString()),
      userId: json['user_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      type: Offer.translateIntToService(json['type'] ?? 0),
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
      applicants: applicantsData.map((e) => UserModel.fromJson(e)).toList(),
      user: UserModel.fromJson(json['user']),
      tasks: tasksData.map((e) => Task.fromJson(e)).toList(),
    );
  }
}
