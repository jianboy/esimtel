import 'dart:convert';

PaymentInitiateModel paymentInitiateModelFromJson(String str) =>
    PaymentInitiateModel.fromJson(json.decode(str));

String paymentInitiateModelToJson(PaymentInitiateModel data) =>
    json.encode(data.toJson());

class PaymentInitiateModel {
  dynamic status;
  Data? data;
  dynamic message;

  PaymentInitiateModel({this.status, this.data, this.message});

  factory PaymentInitiateModel.fromJson(Map<String, dynamic> json) =>
      PaymentInitiateModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  dynamic id;
  dynamic amount;
  dynamic currency;
  dynamic razorpayKey;
  dynamic name;
  dynamic description;
  dynamic email;
  dynamic phone;

  Data({
    this.id,
    this.amount,
    this.currency,
    this.description,
    this.razorpayKey,
    this.name,
    this.email,
    this.phone,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    amount: json["amount"],
    currency: json["currency"],
    razorpayKey: json["key"],
    name: json["name"],
    description: json["description"],
    email: json["email"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "currency": currency,
    "key": razorpayKey,
    "name": name,
    "description": description,
    "email": email,
    "phone": phone,
  };
}
