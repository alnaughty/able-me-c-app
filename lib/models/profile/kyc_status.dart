class KYCStatus {
  final int id;
  final String idType;
  final String selfie;
  final String idFront;
  final String idBack;
  final String? reason;
  final bool isEmailValidated;
  final int status;
  final DateTime uploadedAt;
  const KYCStatus({
    required this.id,
    required this.idType,
    required this.selfie,
    required this.idFront,
    required this.idBack,
    required this.status,
    required this.uploadedAt,
    required this.isEmailValidated,
    this.reason,
  });
  factory KYCStatus.fromJson(Map<String, dynamic> json) {
    return KYCStatus(
      id: json['id'].toInt(),
      idType: json['id_type'],
      selfie: json['selfie'],
      idFront: json['id_front'],
      idBack: json['id_back'],
      isEmailValidated: json['email_validated'] != null,
      status: int.parse(json['status'].toString()),
      reason: json['reason'],
      uploadedAt: DateTime.parse(json['created_at']),
    );
  }
}
