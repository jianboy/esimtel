import 'dart:convert';

PackageDetailsModel packageDetailsModelFromJson(String str) => PackageDetailsModel.fromJson(json.decode(str));

String packageDetailsModelToJson(PackageDetailsModel data) => json.encode(data.toJson());

class PackageDetailsModel {
  dynamic success;
  Data? data;
  dynamic message;

  PackageDetailsModel({this.success, this.data, this.message});

  factory PackageDetailsModel.fromJson(Map<String, dynamic> json) =>
      PackageDetailsModel(
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
  dynamic operatorId;
  dynamic airaloPackageId;
  dynamic name;
  dynamic type;
  dynamic day;
  dynamic isUnlimited;
  dynamic shortInfo;
  dynamic data;
  dynamic price;
  dynamic isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  Prices? prices;
  dynamic netPrice;
  Country? country;
  dynamic isFairUsagePolicy;
  dynamic fairUsagePolicy;
  dynamic qrInstallation; 
  dynamic manualInstallation; 
  Operator? dataOperator;

  Data({
    this.id,
    this.operatorId,
    this.airaloPackageId,
    this.name,
    this.type,
    this.day,
    this.isUnlimited,
    this.shortInfo,
    this.data,
    this.price,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.prices,
    this.netPrice,
    this.country,
    this.isFairUsagePolicy,
    this.fairUsagePolicy,
    this.qrInstallation,
    this.manualInstallation,
    this.dataOperator,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    operatorId: json["operator_id"],
    airaloPackageId: json["airalo_package_id"],
    name: json["name"],
    type: json["type"],
    day: json["day"],
    isUnlimited: json["is_unlimited"],
    shortInfo: json["short_info"],
    data: json["data"],
    price: json["price"],
    isActive: json["is_active"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    prices: json["prices"] == null ? null : Prices.fromJson(json["prices"]),
    netPrice: json["net_price"], // Parsing as a String
    country: json["country"] == null ? null : Country.fromJson(json["country"]),
    isFairUsagePolicy: json["is_fair_usage_policy"],
    fairUsagePolicy: json["fair_usage_policy"],
    qrInstallation: json["qr_installation"],
    manualInstallation: json["manual_installation"],
    dataOperator: json["operator"] == null
        ? null
        : Operator.fromJson(json["operator"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "operator_id": operatorId,
    "airalo_package_id": airaloPackageId,
    "name": name,
    "type": type,
    "day": day,
    "is_unlimited": isUnlimited,
    "short_info": shortInfo,
    "data": data,
    "price": price,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "prices": prices?.toJson(),
    "net_price": netPrice,
    "country": country?.toJson(),
    "is_fair_usage_policy": isFairUsagePolicy,
    "fair_usage_policy": fairUsagePolicy,
    "qr_installation": qrInstallation,
    "manual_installation": manualInstallation,
    "operator": dataOperator?.toJson(),
  };
}

class Country {
  dynamic id;
  dynamic name;
  dynamic slug;
  dynamic countryCode;
  dynamic image;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic laravelThroughKey;

  Country({
    this.id,
    this.name,
    this.slug,
    this.countryCode,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.laravelThroughKey,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    countryCode: json["country_code"],
    image: json["image"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    laravelThroughKey: json["laravel_through_key"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "country_code": countryCode,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "laravel_through_key": laravelThroughKey,
  };
}

class Prices {
  Map<dynamic, double>? netPrice;
  Map<dynamic, double>? recommendedRetailPrice;

  Prices({this.netPrice, this.recommendedRetailPrice});

  factory Prices.fromJson(Map<String, dynamic> json) => Prices(
    netPrice: Map.from(
      json["net_price"]!,
    ).map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
    recommendedRetailPrice: Map.from(
      json["recommended_retail_price"]!,
    ).map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "net_price": Map.from(
      netPrice!,
    ).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "recommended_retail_price": Map.from(
      recommendedRetailPrice!,
    ).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}

class Operator {
  dynamic id;
  dynamic name;
  dynamic countryId;
  dynamic airaloOperatorId;
  dynamic type;
  dynamic isPrepaid;
  dynamic esimType;
  dynamic apnType;
  dynamic apnValue;
  dynamic info;
  dynamic image;
  dynamic planType;
  dynamic activationPolicy;
  dynamic isKycVerify;
  dynamic rechargeability;
  DateTime? createdAt;
  DateTime? updatedAt;

  Operator({
    this.id,
    this.name,
    this.countryId,
    this.airaloOperatorId,
    this.type,
    this.isPrepaid,
    this.esimType,
    this.apnType,
    this.apnValue,
    this.info,
    this.image,
    this.planType,
    this.activationPolicy,
    this.isKycVerify,
    this.rechargeability,
    this.createdAt,
    this.updatedAt,
  });

  factory Operator.fromJson(Map<String, dynamic> json) => Operator(
    id: json["id"],
    name: json["name"],
    countryId: json["country_id"],
    airaloOperatorId: json["airaloOperatorId"],
    type: json["type"],
    isPrepaid: json["is_prepaid"],
    esimType: json["esim_type"],
    apnType: json["apn_type"],
    apnValue: json["apn_value"],
    info: json["info"],
    image: json["image"],
    planType: json["plan_type"],
    activationPolicy: json["activation_policy"],
    isKycVerify: json["is_kyc_verify"],
    rechargeability: json["rechargeability"],
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
    "country_id": countryId,
    "airaloOperatorId": airaloOperatorId,
    "type": type,
    "is_prepaid": isPrepaid,
    "esim_type": esimType,
    "apn_type": apnType,
    "apn_value": apnValue,
    "info": info,
    "image": image,
    "plan_type": planType,
    "activation_policy": activationPolicy,
    "is_kyc_verify": isKycVerify,
    "rechargeability": rechargeability,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
