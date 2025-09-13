class UserProfileModel {
  dynamic success;
  Data? data;
  dynamic message;

  UserProfileModel({this.success, this.data, this.message});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  dynamic id;
  dynamic name;
  dynamic email;
  dynamic imagePath;
  dynamic role;
  dynamic emailVerifiedAt;
  dynamic otp;
  dynamic otpExpiresAt;
  dynamic country;
  dynamic countryCode;
  dynamic currencyId;
  dynamic isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  Currency? currency;
  dynamic kycstatus;
  dynamic refCode;
  dynamic refBy;
  dynamic referral_point;
  dynamic totalUnreadNoti;
  dynamic payment_mode;

  Data({
    this.id,
    this.name,
    this.imagePath,
    this.email,
    this.role,
    this.emailVerifiedAt,
    this.otp,
    this.otpExpiresAt,
    this.country,
    this.countryCode,
    this.currencyId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.currency,
    this.kycstatus,
    this.refCode,
    this.refBy,
    this.referral_point,
    this.totalUnreadNoti,
    this.payment_mode,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    imagePath: json["image"],
    email: json["email"],
    role: json["role"],
    emailVerifiedAt: json["email_verified_at"],
    otp: json["otp"],
    otpExpiresAt: json["otp_expires_at"],
    country: json["country"],
    countryCode: json["countryCode"],
    currencyId: json["currencyId"],
    isActive: json["is_active"],
    refCode: json["refCode"],
    refBy: json["refBy"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    currency: json["currency"] == null
        ? null
        : Currency.fromJson(json["currency"]),
    kycstatus: json["kyc_status"],
    referral_point: json["referral_point"],
    payment_mode: json["payment_mode"],
    totalUnreadNoti: json["notification_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": imagePath,
    "email": email,
    "role": role,
    "email_verified_at": emailVerifiedAt,
    "otp": otp,
    "refCode": refCode,
    "refBy": refBy,
    "otp_expires_at": otpExpiresAt,
    "country": country,
    "countryCode": countryCode,
    "currencyId": currencyId,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "currency": currency?.toJson(),
    "kyc_status": kycstatus,
    "referral_point": referral_point,
    "payment_mode": payment_mode,
    "notification_count": totalUnreadNoti,
  };
}

class Currency {
  dynamic id;
  dynamic name;
  dynamic symbol;
  dynamic isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  Currency({
    this.id,
    this.name,
    this.symbol,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"],
    name: json["name"],
    symbol: json["symbol"],
    isActive: json["is_active"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "symbol": name,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
