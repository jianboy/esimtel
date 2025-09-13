
class CountryListModel {
  final bool? success;
  final List<Country>? data;
  final String? message;

  CountryListModel({this.success, this.data, this.message});

  factory CountryListModel.fromJson(Map<String, dynamic> json) {
    return CountryListModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? List<Country>.from(json['data'].map((x) => Country.fromJson(x)))
          : [],
    );
  }
}

class Country {
  final int? id;
  final String? name;
  final String? slug;
  final String? countryCode;
  final String? image;
  final dynamic startedfrom;
  final String? createdAt;
  final String? updatedAt;

  Country({
    this.id,
    this.name,
    this.slug,
    this.countryCode,
    this.image,
    this.startedfrom,
    this.createdAt,
    this.updatedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      countryCode: json['country_code'],
      image: json['image'],
      startedfrom: json['start_price'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
