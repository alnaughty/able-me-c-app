class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String lastName;
  final DateTime? birthdate;
  final String? phone;
  final bool hasDisabilityCard;
  final int accountType;
  final bool isSenior;
  final String fullname;
  final bool isKYCVerified;
  final bool isEmailVerified;
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.lastName,
    required this.birthdate,
    required this.phone,
    required this.hasDisabilityCard,
    required this.accountType,
    required this.isSenior,
    required this.fullname,
    required this.isKYCVerified,
    required this.isEmailVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      avatar: json['avatar'],
      lastName: json['lastname'],
      birthdate:
          json['birthday'] == null ? null : DateTime.tryParse(json['birthday']),
      phone: json['phone_number'],
      hasDisabilityCard: json['is_disability'] == 1,
      accountType: json['account_type'],
      isSenior: json['is_senior'] == 1,
      fullname: json['fullname'],
      isEmailVerified: json['is_email_verfied'] == 1,
      isKYCVerified: json['is_verified'] == 1);

  @override
  String toString() {
    return "${toMap()}";
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "birthday": birthdate?.toIso8601String(),
        "phone": phone,
        "is_disability": hasDisabilityCard,
        "accountType": accountType,
        "is_senior": isSenior,
        "email": email,
        "fullname": fullname,
      };

  UserModel copyWith({
    String? name,
    String? lastName,
    bool? hasDisabilityCard,
    bool? isSenior,
    int? accountType,
    DateTime? birthdate,
    String? phone,
    bool? isKYCVerified,
    bool? isEmailVerified,
  }) =>
      UserModel(
          id: id,
          name: name ?? this.name,
          email: email,
          avatar: avatar,
          lastName: lastName ?? this.lastName,
          birthdate: birthdate,
          phone: phone,
          hasDisabilityCard: hasDisabilityCard ?? this.hasDisabilityCard,
          accountType: accountType ?? this.accountType,
          isSenior: isSenior ?? this.isSenior,
          fullname: fullname,
          isKYCVerified: isKYCVerified ?? this.isKYCVerified,
          isEmailVerified: isEmailVerified ?? this.isEmailVerified);
}
