// To parse this JSON data, do
//
//     final deviceInfoModel = deviceInfoModelFromJson(jsonString);

import 'dart:convert';

DeviceInfoModel deviceInfoModelFromJson(String str) =>
    DeviceInfoModel.fromJson(json.decode(str));

String deviceInfoModelToJson(DeviceInfoModel data) => json.encode(data.toJson());

class DeviceInfoModel {
  final bool? success;
  final List<DeviceData>? data;

  DeviceInfoModel({
    this.success,
    this.data,
  });

  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) => DeviceInfoModel(
    success: json["success"],
    data: json["data"] == null
        ? []
        : List<DeviceData>.from(json["data"]!.map((x) => DeviceData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class DeviceData {
  final String? model;
  final String? os;
  final String? brand;
  final String? name;

  DeviceData({
    this.model,
    this.os,
    this.brand,
    this.name,
  });

  factory DeviceData.fromJson(Map<String, dynamic> json) => DeviceData(
    model: json["model"],
    os: json["os"],
    brand: json["brand"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "os": os,
    "brand": brand,
    "name": name,
  };
}