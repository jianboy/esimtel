import 'package:equatable/equatable.dart';

class PaymentVerifyModel extends Equatable {
  final bool? success;
  final String? message;
  final Order? order;
  final User? user;

  const PaymentVerifyModel({
    this.success,
    this.message,
    this.order,
    this.user,
  });

  factory PaymentVerifyModel.fromJson(Map<String, dynamic> json) {
    return PaymentVerifyModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      order: json['order'] != null ? Order.fromJson(json['order'] as Map<String, dynamic>) : null,
      user: json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null,
    );
  }

  @override
  List<Object?> get props => [success, message, order, user];
}

// Model for the 'order' object.
class Order extends Equatable {
  final int? id;
  final int? userId;
  final int? esimPackageId;
  final int? currencyId;
  final double? airaloPrice;
  final String? orderRef;
  final int? gst;
  final String? totalAmount;
  final String? status;
  final dynamic activationDetails;
  final dynamic webhookRequestId;
  final dynamic userNote;
  final dynamic adminNote;
  final String? createdAt;
  final String? updatedAt;
  final Package? package;

  const Order({
    this.id,
    this.userId,
    this.esimPackageId,
    this.currencyId,
    this.airaloPrice,
    this.orderRef,
    this.gst,
    this.totalAmount,
    this.status,
    this.activationDetails,
    this.webhookRequestId,
    this.userNote,
    this.adminNote,
    this.createdAt,
    this.updatedAt,
    this.package,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      esimPackageId: json['esim_package_id'] as int?,
      currencyId: json['currency_id'] as int?,
      airaloPrice: json['airalo_price'] as double?,
      orderRef: json['order_ref'] as String?,
      gst: json['gst'] as int?,
      totalAmount: json['total_amount'] as String?,
      status: json['status'] as String?,
      activationDetails: json['activation_details'],
      webhookRequestId: json['webhook_request_id'],
      userNote: json['user_note'],
      adminNote: json['admin_note'],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      package: json['package'] != null ? Package.fromJson(json['package'] as Map<String, dynamic>) : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        esimPackageId,
        currencyId,
        airaloPrice,
        orderRef,
        gst,
        totalAmount,
        status,
        activationDetails,
        webhookRequestId,
        userNote,
        adminNote,
        createdAt,
        updatedAt,
        package,
      ];
}

class Package extends Equatable {
  final int? id;
  final int? operatorId;
  final String? airaloPackageId;
  final String? name;
  final String? type;
  final String? price;
  final String? amount;
  final int? day;
  final bool? isUnlimited;
  final String? shortInfo;
  final String? qrInstallation;
  final String? manualInstallation;
  final bool? isFairUsagePolicy;
  final dynamic fairUsagePolicy;
  final String? data;
  final String? netPrice;
  final Prices? prices;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  const Package({
    this.id,
    this.operatorId,
    this.airaloPackageId,
    this.name,
    this.type,
    this.price,
    this.amount,
    this.day,
    this.isUnlimited,
    this.shortInfo,
    this.qrInstallation,
    this.manualInstallation,
    this.isFairUsagePolicy,
    this.fairUsagePolicy,
    this.data,
    this.netPrice,
    this.prices,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'] as int?,
      operatorId: json['operator_id'] as int?,
      airaloPackageId: json['airalo_package_id'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      price: json['price'] as String?,
      amount: json['amount'] as String?,
      day: json['day'] as int?,
      isUnlimited: json['is_unlimited'] as bool?,
      shortInfo: json['short_info'] as String?,
      qrInstallation: json['qr_installation'] as String?,
      manualInstallation: json['manual_installation'] as String?,
      isFairUsagePolicy: json['is_fair_usage_policy'] as bool?,
      fairUsagePolicy: json['fair_usage_policy'],
      data: json['data'] as String?,
      netPrice: json['net_price'] as String?,
      prices: json['prices'] != null ? Prices.fromJson(json['prices'] as Map<String, dynamic>) : null,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        operatorId,
        airaloPackageId,
        name,
        type,
        price,
        amount,
        day,
        isUnlimited,
        shortInfo,
        qrInstallation,
        manualInstallation,
        isFairUsagePolicy,
        fairUsagePolicy,
        data,
        netPrice,
        prices,
        isActive,
        createdAt,
        updatedAt,
      ];
}

class Prices extends Equatable {
  final Map<String, double?>? netPrice;
  final Map<String, double?>? recommendedRetailPrice;

  const Prices({
    this.netPrice,
    this.recommendedRetailPrice,
  });

  factory Prices.fromJson(Map<String, dynamic> json) {
    return Prices(
      netPrice: (json['net_price'] as Map?)?.cast<String, double?>(),
      recommendedRetailPrice: (json['recommended_retail_price'] as Map?)?.cast<String, double?>(),
    );
  }

  @override
  List<Object?> get props => [netPrice, recommendedRetailPrice];
}

class User extends Equatable {
  final int? id;
  final dynamic name;
  final String? email;
  final String? role;
  final dynamic emailVerifiedAt;
  final dynamic otp;
  final dynamic otpExpiresAt;
  final String? country;
  final String? countryCode;
  final int? currencyId;
  final int? isActive;
  final dynamic image;
  final String? createdAt;
  final String? updatedAt;

  const User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.emailVerifiedAt,
    this.otp,
    this.otpExpiresAt,
    this.country,
    this.countryCode,
    this.currencyId,
    this.isActive,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      name: json['name'],
      email: json['email'] as String?,
      role: json['role'] as String?,
      emailVerifiedAt: json['email_verified_at'],
      otp: json['otp'],
      otpExpiresAt: json['otp_expires_at'],
      country: json['country'] as String?,
      countryCode: json['countryCode'] as String?,
      currencyId: json['currencyId'] as int?,
      isActive: json['is_active'] as int?,
      image: json['image'],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        role,
        emailVerifiedAt,
        otp,
        otpExpiresAt,
        country,
        countryCode,
        currencyId,
        isActive,
        image,
        createdAt,
        updatedAt,
      ];
}
