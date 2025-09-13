import 'dart:convert';

OrderHistoryModel orderHistoryModelFromJson(String str) =>
    OrderHistoryModel.fromJson(json.decode(str));

String orderHistoryModelToJson(OrderHistoryModel data) =>
    json.encode(data.toJson());

class OrderHistoryModel {
  bool success;
  OrderHistoryData data;
  String message;

  OrderHistoryModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      OrderHistoryModel(
        success: json["success"],
        data: OrderHistoryData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "message": message,
  };
}

class OrderHistoryData {
  dynamic currentPage;
  List<EsimOrder> data;
  dynamic firstPageUrl;
  dynamic from;
  dynamic lastPage;
  dynamic lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  dynamic path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  OrderHistoryData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory OrderHistoryData.fromJson(Map<dynamic, dynamic> json) =>
      OrderHistoryData(
        currentPage: json["current_page"],
        data: List<EsimOrder>.from(
          json["data"].map((x) => EsimOrder.fromJson(x)),
        ),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<dynamic, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class Link {
  dynamic url;
  dynamic label;
  bool active;

  Link({this.url, required this.label, required this.active});

  factory Link.fromJson(Map<String, dynamic> json) =>
      Link(url: json["url"], label: json["label"], active: json["active"]);

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}

class EsimOrder {
  dynamic id;
  dynamic userId;
  dynamic esimPackageId;
  dynamic orderRef;
  dynamic gst;
  dynamic totalAmount;
  dynamic status;
  ActivationDetails? activationDetails;
  dynamic webhookRequestId;
  dynamic userNote;
  dynamic adminNote;
  DateTime createdAt;
  DateTime updatedAt;

  EsimOrder({
    required this.id,
    required this.userId,
    required this.esimPackageId,
    required this.orderRef,
    required this.gst,
    required this.totalAmount,
    required this.status,
    this.activationDetails,
    this.webhookRequestId,
    this.userNote,
    this.adminNote,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EsimOrder.fromJson(Map<String, dynamic> json) => EsimOrder(
    id: json["id"],
    userId: json["user_id"],
    esimPackageId: json["esim_package_id"],
    orderRef: json["order_ref"],
    gst: json["gst"],
    totalAmount: json["total_amount"],
    status: json["status"],
    activationDetails: json["activation_details"] != null
        ? ActivationDetails.fromJson(json["activation_details"])
        : null,
    webhookRequestId: json["webhook_request_id"],
    userNote: json["user_note"],
    adminNote: json["admin_note"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "esim_package_id": esimPackageId,
    "order_ref": orderRef,
    "gst": gst,
    "total_amount": totalAmount,
    "status": status,
    "activation_details": activationDetails?.toJson(),
    "webhook_request_id": webhookRequestId,
    "user_note": userNote,
    "admin_note": adminNote,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class ActivationDetails {
  dynamic id;
  dynamic code;
  dynamic currency;
  dynamic packageId;
  dynamic quantity;
  dynamic type;
  dynamic description;
  dynamic esimType;
  dynamic validity;
  dynamic packageName;
  dynamic data;
  dynamic price;
  DateTime? createdAt;
  dynamic manualInstallation;
  dynamic qrcodeInstallation;
  Map<String, String>? installationGuides;
  dynamic text;
  dynamic voice;
  dynamic netPrice;
  dynamic brandSettingsName;
  List<Sim>? sims;
  dynamic error;

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
    // if (json.containsKey('error') && json['error'] is String) {
    //   return ActivationDetails(
    //     error: json['error'] as String,
    //     id: null,
    //     code: null,
    //     currency: null,
    //     packageId: null,
    //     quantity: null,
    //     type: null,
    //     description: null,
    //     esimType: null,
    //     validity: null,
    //     packageName: null,
    //     data: null,
    //     price: null,
    //     createdAt: null,
    //     manualInstallation: null,
    //     qrcodeInstallation: null,
    //     installationGuides: null,
    //     text: null,
    //     voice: null,
    //     netPrice: null,
    //     brandSettingsName: null,
    //     sims: null,
    //   );
    // }
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
  dynamic id;
  DateTime createdAt;
  dynamic iccid;
  dynamic lpa;
  dynamic imsis;
  dynamic matchingId;
  dynamic qrcode;
  dynamic qrcodeUrl;
  dynamic airaloCode;
  ApnType apnType;
  ApnValue apnValue;
  dynamic isRoaming;
  dynamic confirmationCode;
  Apn apn;
  dynamic msisdn;
  dynamic directAppleInstallationUrl;

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
    apnValue: apnValueValues.map[json["apn_value"]] ?? ApnValue.GLOBALDATA,
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
    apnValue: apnValueValues.map[json["apn_value"]] ?? ApnValue.GLOBALDATA,
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

enum ApnValue { GLOBALDATA }

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
