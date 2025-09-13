// --- Mock JSON Data (Updated to your latest structure) ---
import 'dart:convert';

EsimListModel EsimListModelFromJson(String str) =>
    EsimListModel.fromJson(json.decode(str));
String EsimListModelToJson(EsimListModel data) => json.encode(data.toJson());

class EsimListModel {
  bool success;
  List<EsimItem> data;
  String message;

  EsimListModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory EsimListModel.fromJson(Map<String, dynamic> json) => EsimListModel(
    success: json["success"],
    data: List<EsimItem>.from(json["data"].map((x) => EsimItem.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class EsimItem {
  int id;
  int userId;
  int orderId;
  int packageId;
  String iccid;
  dynamic imsis;
  String matchingId;
  String qrcode;
  String qrcodeUrl;
  dynamic airaloCode;
  ApnType apnType;
  ApnValue apnValue;
  int isRoaming; // Changed to int to match JSON
  dynamic confirmationCode;
  Apn apn;
  dynamic msisdn;
  String directAppleInstallationUrl;
  String status;
  dynamic remaining;
  DateTime? activatedAt;
  DateTime? expiredAt;
  DateTime? finishedAt;
  DateTime createdAt;
  DateTime updatedAt;
  Order? order; // NEW: Nested Order object

  EsimItem({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.packageId,
    required this.iccid,
    this.imsis,
    required this.matchingId,
    required this.qrcode,
    required this.qrcodeUrl,
    this.airaloCode,
    required this.apnType,
    required this.apnValue,
    required this.isRoaming,
    this.confirmationCode,
    required this.apn,
    this.msisdn,
    required this.directAppleInstallationUrl,
    required this.status,
    this.remaining,
    this.activatedAt,
    this.expiredAt,
    this.finishedAt,
    required this.createdAt,
    required this.updatedAt,
    this.order, // NEW
  });

  factory EsimItem.fromJson(Map<String, dynamic> json) => EsimItem(
    id: json["id"],
    userId: json["user_id"],
    orderId: json["order_id"],
    packageId: json["package_id"],
    iccid: json["iccid"],
    imsis: json["imsis"],
    matchingId: json["matching_id"],
    qrcode: json["qrcode"],
    qrcodeUrl: json["qrcode_url"],
    airaloCode: json["airalo_code"],
    apnType: apnTypeValues.map[json["apn_type"]] ?? ApnType.MANUAL,
    apnValue: apnValueValues.map[json["apn_value"]] ?? ApnValue.UNKNOWN,

    isRoaming: json["is_roaming"],
    confirmationCode: json["confirmation_code"],
    apn: Apn.fromJson(json["apn"]),
    msisdn: json["msisdn"],
    directAppleInstallationUrl: json["direct_apple_installation_url"],
    status: json["status"],
    remaining: json["remaining"],
    activatedAt: json["activated_at"] == null
        ? null
        : DateTime.parse(json["activated_at"]),
    expiredAt: json["expired_at"] == null
        ? null
        : DateTime.parse(json["expired_at"]),
    finishedAt: json["finished_at"] == null
        ? null
        : DateTime.parse(json["finished_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    order: json["order"] == null ? null : Order.fromJson(json["order"]), // NEW
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "order_id": orderId,
    "package_id": packageId,
    "iccid": iccid,
    "imsis": imsis,
    "matching_id": matchingId,
    "qrcode": qrcode,
    "qrcode_url": qrcodeUrl,
    "airalo_code": airaloCode,
    "apn_type": apnTypeValues.reverse[apnType],
    "apn_value": apnValueValues.reverse[apnValue],
    "is_roaming": isRoaming,
    "confirmation_code": confirmationCode,
    "apn": apn.toJson(),
    "msisdn": msisdn,
    "direct_apple_installation_url": directAppleInstallationUrl,
    "status": status,
    "remaining": remaining,
    "activated_at": activatedAt?.toIso8601String(),
    "expired_at": expiredAt?.toIso8601String(),
    "finished_at": finishedAt?.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "order": order?.toJson(), // NEW
  };
}

// NEW: Order class
class Order {
  int id;
  String orderRef;
  ActivationDetails? activationDetails;

  Order({required this.id, required this.orderRef, this.activationDetails});

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    orderRef: json["order_ref"],
    activationDetails: json["activation_details"] == null
        ? null
        : (json["activation_details"] is Map<String, dynamic>
              ? ActivationDetails.fromJson(json["activation_details"])
              : null),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_ref": orderRef,
    "activation_details": activationDetails?.toJson(),
  };
}

class ActivationDetails {
  int? id;
  String? code;
  String? currency;
  String? packageId;
  int? quantity;
  String? type;
  dynamic description;
  String? esimType;
  int? validity;
  String? packageName; // Renamed from 'package' to avoid conflict
  String? data;
  double? price;
  DateTime? createdAt;
  String? manualInstallation;
  String? qrcodeInstallation;
  Map<String, String>? installationGuides;
  dynamic text;
  dynamic voice;
  double? netPrice;
  dynamic brandSettingsName;
  List<Sim>? sims;
  String? error;

  ActivationDetails({
    this.id,
    this.code,
    this.currency,
    this.packageId,
    this.quantity,
    this.type,
    this.description,
    this.esimType,
    this.validity,
    this.packageName,
    this.data,
    this.price,
    this.createdAt,
    this.manualInstallation,
    this.qrcodeInstallation,
    this.installationGuides,
    this.text,
    this.voice,
    this.netPrice,
    this.brandSettingsName,
    this.sims,
    this.error,
  });

  factory ActivationDetails.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error') && json['error'] is String) {
      return ActivationDetails(
        error: json['error'] as String,
        id: null,
        code: null,
        currency: null,
        packageId: null,
        quantity: null,
        type: null,
        description: null,
        esimType: null,
        validity: null,
        packageName: null,
        data: null,
        price: null,
        createdAt: null,
        manualInstallation: null,
        qrcodeInstallation: null,
        installationGuides: null,
        text: null,
        voice: null,
        netPrice: null,
        brandSettingsName: null,
        sims: null,
      );
    }
    return ActivationDetails(
      id: json["id"],
      code: json["code"],
      currency: json["currency"],
      packageId: json["package_id"],
      quantity: json["quantity"],
      type: json["type"],
      description: json["description"],
      esimType: json["esim_type"],
      validity: json["validity"],
      packageName: json["package"],
      data: json["data"],
      price: json["price"]?.toDouble(),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      manualInstallation: json["manual_installation"],
      qrcodeInstallation: json["qrcode_installation"],
      installationGuides: json["installation_guides"] == null
          ? null
          : Map<String, String>.from(json["installation_guides"]),
      text: json["text"],
      voice: json["voice"],
      netPrice: json["net_price"]?.toDouble(),
      brandSettingsName: json["brand_settings_name"],
      sims: json["sims"] == null
          ? []
          : List<Sim>.from(json["sims"]!.map((x) => Sim.fromJson(x))),
      error: null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "currency": currency,
    "package_id": packageId,
    "quantity": quantity,
    "type": type,
    "description": description,
    "esim_type": esimType,
    "validity": validity,
    "package": packageName,
    "data": data,
    "price": price,
    "created_at": createdAt?.toIso8601String(),
    "manual_installation": manualInstallation,
    "qrcode_installation": qrcodeInstallation,
    "installation_guides": installationGuides,
    "text": text,
    "voice": voice,
    "net_price": netPrice,
    "brand_settings_name": brandSettingsName,
    "sims": sims == null
        ? []
        : List<dynamic>.from(sims!.map((x) => x.toJson())),
    "error": error,
  };
}

class Sim {
  int id;
  DateTime createdAt;
  String iccid;
  String lpa;
  dynamic imsis;
  String matchingId;
  String qrcode;
  String qrcodeUrl;
  dynamic airaloCode;
  ApnType apnType;
  ApnValue apnValue;
  dynamic isRoaming; // Changed to int to match JSON
  dynamic confirmationCode;
  Apn apn;
  dynamic msisdn;
  String directAppleInstallationUrl;

  Sim({
    required this.id,
    required this.createdAt,
    required this.iccid,
    required this.lpa,
    this.imsis,
    required this.matchingId,
    required this.qrcode,
    required this.qrcodeUrl,
    this.airaloCode,
    required this.apnType,
    required this.apnValue,
    required this.isRoaming,
    this.confirmationCode,
    required this.apn,
    this.msisdn,
    required this.directAppleInstallationUrl,
  });

  factory Sim.fromJson(Map<String, dynamic> json) => Sim(
    id: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
    iccid: json["iccid"],
    lpa: json["lpa"],
    imsis: json["imsis"],
    matchingId: json["matching_id"],
    qrcode: json["qrcode"],
    qrcodeUrl: json["qrcode_url"],
    airaloCode: json["airalo_code"],
    apnType: apnTypeValues.map[json["apn_type"]] ?? ApnType.MANUAL,
    apnValue: apnValueValues.map[json["apn_value"]] ?? ApnValue.UNKNOWN,
    isRoaming: json["is_roaming"],
    confirmationCode: json["confirmation_code"],
    apn: Apn.fromJson(json["apn"]),
    msisdn: json["msisdn"],
    directAppleInstallationUrl: json["direct_apple_installation_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt.toIso8601String(),
    "iccid": iccid,
    "lpa": lpa,
    "imsis": imsis,
    "matching_id": matchingId,
    "qrcode": qrcode,
    "qrcode_url": qrcodeUrl,
    "airalo_code": airaloCode,
    "apn_type": apnTypeValues.reverse[apnType],
    "apn_value": apnValueValues.reverse[apnValue],
    "is_roaming": isRoaming,
    "confirmation_code": confirmationCode,
    "apn": apn.toJson(),
    "msisdn": msisdn,
    "direct_apple_installation_url": directAppleInstallationUrl,
  };
}

class Apn {
  ApnDetail ios;
  ApnDetail android;

  Apn({required this.ios, required this.android});

  factory Apn.fromJson(Map<String, dynamic> json) => Apn(
    ios: ApnDetail.fromJson(json["ios"]),
    android: ApnDetail.fromJson(json["android"]),
  );

  Map<String, dynamic> toJson() => {
    "ios": ios.toJson(),
    "android": android.toJson(),
  };
}

class ApnDetail {
  ApnType apnType;
  ApnValue apnValue;

  ApnDetail({required this.apnType, required this.apnValue});

  factory ApnDetail.fromJson(Map<String, dynamic> json) => ApnDetail(
    apnType: apnTypeValues.map[json["apn_type"]] ?? ApnType.MANUAL,
    apnValue: apnValueValues.map[json["apn_value"]] ?? ApnValue.UNKNOWN,
  );

  Map<String, dynamic> toJson() => {
    "apn_type": apnTypeValues.reverse[apnType],
    "apn_value": apnValueValues.reverse[apnValue],
  };
}

enum ApnType { AUTOMATIC, MANUAL }

final apnTypeValues = EnumValues({
  "automatic": ApnType.AUTOMATIC,
  "manual": ApnType.MANUAL,
});

enum ApnValue { GLOBALDATA, UNKNOWN }

final apnValueValues = EnumValues({"globaldata": ApnValue.GLOBALDATA});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
