// To parse this JSON data, do
//
//     final mostPopularListModel = mostPopularListModelFromJson(jsonString);

import 'dart:convert';

MostPopularListModel mostPopularListModelFromJson(String str) => MostPopularListModel.fromJson(json.decode(str));

String mostPopularListModelToJson(MostPopularListModel data) => json.encode(data.toJson());

class MostPopularListModel {
    List<Datum>? data;
    Links? links;
    Meta? meta;
    bool? success;
    String? message;

    MostPopularListModel({
        this.data,
        this.links,
        this.meta,
        this.success,
        this.message,
    });

    factory MostPopularListModel.fromJson(Map<String, dynamic> json) => MostPopularListModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": links?.toJson(),
        "meta": meta?.toJson(),
        "success": success,
        "message": message,
    };
}

class Datum {
    int? id;
    int? operatorId;
    String? airaloPackageId;
    String? name;
    String? type;
    int? day;
    bool? isUnlimited;
    dynamic shortInfo;
    String? data;
    int? netPrice;
    Country? country;
    dynamic region;
    bool? isActive;
    bool? isPopular;
    DateTime? createdAt;
    DateTime? updatedAt;

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
        this.isPopular,
        this.createdAt,
        this.updatedAt,
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
        country: json["country"] == null ? null : Country.fromJson(json["country"]),
        region: json["region"],
        isActive: json["is_active"],
        isPopular: json["is_popular"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
        "country": country?.toJson(),
        "region": region,
        "is_active": isActive,
        "is_popular": isPopular,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Country {
    int? id;
    int? regionId;
    String? name;
    String? slug;
    String? countryCode;
    String? image;
    DateTime? createdAt;
    DateTime? updatedAt;

    Country({
        this.id,
        this.regionId,
        this.name,
        this.slug,
        this.countryCode,
        this.image,
        this.createdAt,
        this.updatedAt,
    });

    factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        regionId: json["region_id"],
        name: json["name"],
        slug: json["slug"],
        countryCode: json["country_code"],
        image: json["image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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

class Links {
    String? first;
    String? last;
    dynamic prev;
    String? next;

    Links({
        this.first,
        this.last,
        this.prev,
        this.next,
    });

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
    int? currentPage;
    int? from;
    int? lastPage;
    List<Link>? links;
    String? path;
    int? perPage;
    int? to;
    int? total;

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
        links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
    };
}

class Link {
    String? url;
    String? label;
    bool? active;

    Link({
        this.url,
        this.label,
        this.active,
    });

    factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
    };
}
