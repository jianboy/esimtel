import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:esimtel/views/packageModule/packagesList/model/ordernowModel.dart';

typedef PaymentSuccessCallback = void Function();
typedef PaymentFailureCallback = void Function(Map<String, dynamic> errorData);

class StripeService {
  StripeService._();
  static final StripeService _instance = StripeService._();
  static StripeService get instance => _instance;

  Future<void> openPayment({
    required BuildContext context,
    required Data? data,
    required PaymentSuccessCallback onSuccess,
    required PaymentFailureCallback onFailure,
  }) async {
    if (data == null || data.clientSecret == null) {
      Fluttertoast.showToast(msg: "Stripe payment data is incomplete.");
      onFailure({'message': 'Payment data incomplete'});
      return;
    }

    try {
      // 1. Initialize the Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'eSimtel',
          paymentIntentClientSecret: data.clientSecret,
          style: Theme.of(context).brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      onSuccess();
    } on StripeException catch (e) {
      final errorData = {
        "code": e.error.code.toString(),
        "message": e.error.message ?? '',
        "type": e.error.type?.toString(),
        "localizedMessage": e.error.localizedMessage ?? '',
      };
      log('Stripe error: ${jsonEncode(errorData)}');
      onFailure(errorData); // Trigger the failure callback with error details
      Fluttertoast.showToast(
        msg: 'Payment failed: ${e.error.localizedMessage}',
      );
    } catch (e) {
      log('Stripe general error: $e');
      onFailure({'message': 'An unexpected error occurred during payment.'});
      Fluttertoast.showToast(msg: "An error occurred during payment.");
    }
  }
}
