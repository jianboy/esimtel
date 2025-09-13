class BannersModel {
  bool success;
  List<Datum> data;
  String message;

  BannersModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory BannersModel.fromJson(Map<String, dynamic> json) => BannersModel(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  int id;
  String name;
  String image;
  int isActive;
  int packageId;
  DateTime bannerFrom;
  DateTime bannerTo;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.name,
    required this.image,
    required this.isActive,
    required this.packageId,
    required this.bannerFrom,
    required this.bannerTo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    isActive: json["is_active"],
    packageId: json["package_id"],
    bannerFrom: DateTime.parse(json["banner_from"]),
    bannerTo: DateTime.parse(json["banner_to"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "is_active": isActive,
    "package_id": packageId,
    "banner_from":
        "${bannerFrom.year.toString().padLeft(4, '0')}-${bannerFrom.month.toString().padLeft(2, '0')}-${bannerFrom.day.toString().padLeft(2, '0')}",
    "banner_to":
        "${bannerTo.year.toString().padLeft(4, '0')}-${bannerTo.month.toString().padLeft(2, '0')}-${bannerTo.day.toString().padLeft(2, '0')}",
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
