import 'dart:convert';
OrderNowModel orderNowModelFromJson(String str) => OrderNowModel.fromJson(json.decode(str));

String orderNowModelToJson(OrderNowModel data) => json.encode(data.toJson());

class OrderNowModel {
    bool? success;
    Data? data;
    String? message;

    OrderNowModel({
        this.success,
        this.data,
        this.message,
    });

    factory OrderNowModel.fromJson(Map<String, dynamic> json) => OrderNowModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
    };
}

class Data {
    int? esimOrderId;
    String? gatewayOrderId;
    String? clientSecret;
    int? amount;
    String? currency;
    String? gatewayKey;
    String? name;
    String? description;
    String? phone;
    String? email;
    dynamic iccid;
    dynamic payment_session_id;

    Data({
        this.esimOrderId,
        this.gatewayOrderId,
        this.clientSecret,
        this.amount,
        this.currency,
        this.gatewayKey,
        this.name,
        this.description,
        this.phone,
        this.email,
        this.iccid,this.payment_session_id
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        esimOrderId: json["esim_order_id"],
        gatewayOrderId: json["gateway_order_id"],
        clientSecret: json["client_secret"],
        amount: json["amount"],
        currency: json["currency"],
        gatewayKey: json["gateway_key"],
        name: json["name"],
        description: json["description"],
        phone: json["phone"],
        email: json["email"],
        iccid: json["iccid"],
        payment_session_id: json["payment_session_id"],
    );

    Map<String, dynamic> toJson() => {
        "esim_order_id": esimOrderId,
        "gateway_order_id": gatewayOrderId,
        "client_secret": clientSecret,
        "amount": amount,
        "currency": currency,
        "gateway_key": gatewayKey,
        "name": name,
        "description": description,
        "phone": phone,
        "email": email,
        "iccid": iccid,
        "payment_session_id": payment_session_id
    };
}
