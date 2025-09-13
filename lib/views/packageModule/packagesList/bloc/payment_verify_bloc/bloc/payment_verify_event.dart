import 'package:esimtel/core/bloc/api_event.dart';

class PaymentVerifyEvent extends ApiEvent {
  String? paymentid;
  String? signature;
  String? iccid;
  bool? isTopup;

  dynamic esim_order_id;
  String? packageName;
  String? gateway_order_id;
  String? purchaseToken;
  dynamic googleorderid;

  PaymentVerifyEvent({
    this.paymentid,
    this.signature,
    this.iccid,
    this.isTopup,
    this.esim_order_id,
    this.packageName,
    this.gateway_order_id,
    this.purchaseToken,
    this.googleorderid,
  });
}
