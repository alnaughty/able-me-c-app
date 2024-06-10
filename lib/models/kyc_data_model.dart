class KYCDataModel {
  final String? selfie, front, back, reason;
  final String identity;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final int status;
  const KYCDataModel({
    required this.selfie,
    required this.front,
    required this.back,
    required this.reason,
    required this.identity,
    required this.updatedAt,
    required this.status,
    required this.isEmailVerified,
  });

  factory KYCDataModel.fromJson(Map<String, dynamic> json) => KYCDataModel(
        selfie: json['selfie'],
        front: json['front'],
        back: json['back'],
        reason: json['reason'],
        status: int.tryParse(json['status'].toString()) ?? 0,
        isEmailVerified: json['user']['email_validated'] == null
            ? false
            : json['user']['email_validated'] == 1,
        identity: json['identity'],
        updatedAt: DateTime.parse(json['updated_at'].toString()),
      );

  @override
  String toString() => "${toJson()}";
  Map<String, dynamic> toJson() => {
        "selfie": selfie,
        "front": front,
        "back": back,
        "reason": reason,
        "status": status,
        "email_validated": isEmailVerified,
        "identity": identity,
        "updated_at": updatedAt,
      };
}
