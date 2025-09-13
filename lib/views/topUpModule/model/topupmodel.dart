import 'dart:convert';

TopUpOption topUpOptionFromJson(dynamic str) => TopUpOption.fromJson(json.decode(str));

dynamic topUpOptionToJson(TopUpOption data) => json.encode(data.toJson());

class TopUpOption {
    List<TopUp> data;
    Links? links;
    Meta? meta; 
    dynamic success;
    dynamic message;

    TopUpOption({
        required this.data,
        this.links,
        this.meta,
        required this.success,
        required this.message,
    });

    factory TopUpOption.fromJson(Map<dynamic, dynamic> json) => TopUpOption(
        data: List<TopUp>.from(json["data"].map((x) => TopUp.fromJson(x))),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        success: json["success"],
        message: json["message"],
    );

    Map<dynamic, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links?.toJson(),
        "meta": meta?.toJson(),
        "success": success,
        "message": message,
    };
}

class TopUp {
    dynamic id;
    dynamic type;
    dynamic price;
    dynamic amount;
    dynamic day;
    dynamic isUnlimited;
    dynamic title;
    dynamic data;
    dynamic shortInfo;
    dynamic voice;
    dynamic text;
    dynamic netPrice;
    Country? country;

    TopUp({
        required this.id,
        required this.type,
        required this.price,
        required this.amount,
        required this.day,
        required this.isUnlimited,
        required this.title,
        required this.data,
        required this.shortInfo,
        required this.voice,
        required this.text,
        required this.netPrice,
        this.country,
    });

    factory TopUp.fromJson(Map<dynamic, dynamic> json) => TopUp(
        id: json["id"],
        type: json["type"],
        price: json["price"],
        amount: json["amount"],
        day: json["day"],
        isUnlimited: json["is_unlimited"],
        title: json["title"],
        data: json["data"],
        shortInfo: json["short_info"],
        voice: json["voice"],
        text: json["text"],
        netPrice: json["net_price"]?.toDouble(),
        country: json["country"] != null ? Country.fromJson(json["country"]) : null,
    );

    Map<dynamic, dynamic> toJson() => {
        "id": id,
        "type": type,
        "price": price,
        "amount": amount,
        "day": day,
        "is_unlimited": isUnlimited,
        "title": title,
        "data": data,
        "short_info": shortInfo,
        "voice": voice,
        "text": text,
        "net_price": netPrice,
        "country": country?.toJson(),
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
      createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
  dynamic url;
  dynamic label;
  dynamic active;

  Link({this.url, this.label, this.active});

  factory Link.fromJson(Map<String, dynamic> json) => Link(url: json["url"], label: json["label"], active: json["active"]);

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}