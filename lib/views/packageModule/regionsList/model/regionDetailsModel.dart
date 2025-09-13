class RegionDetailsModel {
  List<Datum>? data;
  Links? links;
  Meta? meta;
  dynamic success;
  dynamic message;

  RegionDetailsModel({
    this.data,
    this.links,
    this.meta,
    this.success,
    this.message,
  });

  factory RegionDetailsModel.fromJson(Map<String, dynamic> json) =>
      RegionDetailsModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
    "success": success,
    "message": message,
  };
}

class Datum {
  dynamic id;
  dynamic operatorId;
  dynamic airaloPackageId;
  dynamic name;
  dynamic type;
  dynamic day;
  dynamic isUnlimited;
  dynamic shortInfo;
  dynamic data;
  dynamic netPrice;
  dynamic country;
  Region? region;
  dynamic isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic text_voice; 
  dynamic is_popular; 
  dynamic is_recommend; 
  dynamic is_best_value; 

  Datum({
    this.id,
    this.operatorId,
    this.airaloPackageId,
    this.name,
    this.type,
    this.day,
    this.isUnlimited,
    this.shortInfo,
    this.data,
    this.netPrice,
    this.country,
    this.region,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.text_voice, 
    this.is_popular, 
    this.is_recommend, 
    this.is_best_value, 
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    operatorId: json["operator_id"],
    airaloPackageId: json["airalo_package_id"],
    name: json["name"],
    type: json["type"],
    day: json["day"],
    isUnlimited: json["is_unlimited"],
    shortInfo: json["short_info"],
    data: json["data"],
    netPrice: json["net_price"],
    country: json["country"],
    region: json["region"] == null ? null : Region.fromJson(json["region"]),
    isActive: json["is_active"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    text_voice: json["text_voice"],
    is_popular: json["is_popular"], 
    is_recommend: json["is_recommend"], 
    is_best_value: json["is_best_value"], 
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
    "net_price": netPrice,
    "country": country,
    "region": region?.toJson(),
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "text_voice": text_voice, 
    "is_popular": is_popular, 
    "is_recommend": is_recommend, 
    "is_best_value": is_best_value,
  };
}

class Region {
  dynamic id;
  dynamic name;
  dynamic slug;
  dynamic image;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Region>? countries;
  dynamic regionId;
  dynamic countryCode;

  Region({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.countries,
    this.regionId,
    this.countryCode,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    image: json["image"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    countries: json["countries"] == null
        ? []
        : List<Region>.from(json["countries"]!.map((x) => Region.fromJson(x))),
    regionId: json["region_id"],
    countryCode: json["country_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "countries": countries == null
        ? []
        : List<dynamic>.from(countries!.map((x) => x.toJson())),
    "region_id": regionId,
    "country_code": countryCode,
  };
}

class Links {
  dynamic first;
  dynamic last;
  dynamic prev;
  dynamic next;

  Links({this.first, this.last, this.prev, this.next});

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  dynamic currentPage;
  dynamic from;
  dynamic lastPage;
  List<Link>? links;
  dynamic path;
  dynamic perPage;
  dynamic to;
  dynamic total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: json["links"] == null
        ? []
        : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": links == null
        ? []
        : List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  dynamic url;
  dynamic label;
  dynamic active;

  Link({this.url, this.label, this.active});

  factory Link.fromJson(Map<String, dynamic> json) =>
      Link(url: json["url"], label: json["label"], active: json["active"]);

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
