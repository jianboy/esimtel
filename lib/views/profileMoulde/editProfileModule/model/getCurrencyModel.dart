class GetCurrencyModel {
  bool? success;
  List<Datum>? data;
  String? message;

  GetCurrencyModel({this.success, this.data, this.message});

  factory GetCurrencyModel.fromJson(Map<String, dynamic> json) =>
      GetCurrencyModel(
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
  String? name;
  String? symbol;

  Datum({this.id, this.name, this.symbol});

  factory Datum.fromJson(Map<String, dynamic> json) =>
      Datum(id: json["id"], name: json["name"], symbol: json["symbol"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "symbol": symbol};
}
