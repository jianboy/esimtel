class VerifyModel {
  bool success;
  String message;
  Data data;

  VerifyModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory VerifyModel.fromJson(Map<String, dynamic> json) => VerifyModel(
    success: json["success"],
    message: json["message"],

    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  User user;
  String token;
  dynamic referral_point;
  dynamic payment_mode;

  Data({
    required this.user,
    required this.token,
    required this.referral_point,
    this.payment_mode,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: User.fromJson(json["user"]),
    token: json["token"],
    referral_point: json["referral_point"],
    payment_mode: json["payment_mode"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "token": token,
    "referral_point": referral_point,
    "payment_mode": payment_mode,
  };
}

class User {
  int id;
  dynamic name;
  String email;
  String role;
  dynamic emailVerifiedAt;
  dynamic otp;
  dynamic otpExpiresAt;
  String country;
  String countryCode;
  int currencyId;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic refCode;
  dynamic refBy;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.emailVerifiedAt,
    required this.otp,
    required this.otpExpiresAt,
    required this.country,
    required this.countryCode,
    required this.currencyId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.refCode,
    required this.refBy,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    emailVerifiedAt: json["email_verified_at"],
    otp: json["otp"],
    otpExpiresAt: json["otp_expires_at"],
    country: json["country"],
    countryCode: json["countryCode"],
    currencyId: json["currencyId"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    refCode: json["refCode"],
    refBy: json["refBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
    "email_verified_at": emailVerifiedAt,
    "otp": otp,
    "otp_expires_at": otpExpiresAt,
    "country": country,
    "countryCode": countryCode,
    "currencyId": currencyId,
    "is_active": isActive,
    "refCode": refCode,
    "refBy": refBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
