class DataUsageModel {
  bool? success;
  List<Datum>? data;
  String? message;

  DataUsageModel({this.success, this.data, this.message});

  factory DataUsageModel.fromJson(Map<String, dynamic> json) => DataUsageModel(
    success: json["success"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  int? id;
  String? iccid;
  String? esimStatus;
  Location? location;
  Usage? usage;

  Datum({this.id, this.iccid, this.esimStatus, this.location, this.usage});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    iccid: json["iccid"],
    esimStatus: json["esim_status"],
    location: json["location"] == null
        ? null
        : Location.fromJson(json["location"]),
    usage: json["usage"] == null ? null : Usage.fromJson(json["usage"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "iccid": iccid,
    "esim_status": esimStatus,
    "location": location?.toJson(),
    "usage": usage?.toJson(),
  };
}

class Location {
  int? id;
  int? regionId;
  String? name;
  String? slug;
  String? countryCode;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  Location({
    this.id,
    this.regionId,
    this.name,
    this.slug,
    this.countryCode,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"],
    regionId: json["region_id"],
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
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "region_id": regionId,
    "name": name,
    "slug": slug,
    "country_code": countryCode,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Usage {
  int? remaining;
  int? total;
  dynamic expiredAt;
  bool? isUnlimited;
  String? status;
  int? remainingVoice;
  int? remainingText;
  int? totalVoice;
  int? totalText;

  Usage({
    this.remaining,
    this.total,
    this.expiredAt,
    this.isUnlimited,
    this.status,
    this.remainingVoice,
    this.remainingText,
    this.totalVoice,
    this.totalText,
  });

  factory Usage.fromJson(Map<String, dynamic> json) => Usage(
    remaining: json["remaining"],
    total: json["total"],
    expiredAt: json["expired_at"],
    isUnlimited: json["is_unlimited"],
    status: json["status"],
    remainingVoice: json["remaining_voice"],
    remainingText: json["remaining_text"],
    totalVoice: json["total_voice"],
    totalText: json["total_text"],
  );

  Map<String, dynamic> toJson() => {
    "remaining": remaining,
    "total": total,
    "expired_at": expiredAt,
    "is_unlimited": isUnlimited,
    "status": status,
    "remaining_voice": remainingVoice,
    "remaining_text": remainingText,
    "total_voice": totalVoice,
    "total_text": totalText,
  };
}
