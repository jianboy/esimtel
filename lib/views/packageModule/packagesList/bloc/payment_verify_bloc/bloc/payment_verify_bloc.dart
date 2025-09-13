import 'package:dio/dio.dart';
import 'package:esimtel/utills/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import '../model/paymentverifyModel.dart';
import 'payment_verify_event.dart';

class PaymentVerifybloc
    extends
        ApiBloc<
          PaymentVerifyEvent,
          ApiState<PaymentVerifyModel>,
          PaymentVerifyModel
        > {
  final ApiService apiService;

  PaymentVerifybloc(this.apiService) : super(ApiInitial()) {
    on<PaymentVerifyEvent>(_onPaymentVerified);
  }

  Future<void> _onPaymentVerified(
    PaymentVerifyEvent event,
    Emitter<ApiState<PaymentVerifyModel>> emit,
  ) async {
    emit(loadingState());
    try {
      final result = await executeApiCall(event);
      emit(successState(result));
    } catch (e) {
      emit(errorState(e.toString()));
    }
  }

  @override
  Future<PaymentVerifyModel> executeApiCall(PaymentVerifyEvent event) async {
    Map<String, dynamic> parameterbody = {};
    // 0 for strip enablesd and 1 For Razorpay
    String isStripeEnabled = global.paymentMode;
    if (isStripeEnabled == 'Razorpay') { //Stripe, Cashfree
      //razorpay
      parameterbody["razorpay_payment_id"] = event.paymentid;
      parameterbody["gateway_order_id"] = event.gateway_order_id;
      parameterbody["razorpay_signature"] = event.signature;
    } else {
      //strip
      parameterbody["gateway_order_id"] = event.gateway_order_id;

      // for playstore billing
      parameterbody["order_id"] = event.esim_order_id;
      parameterbody["package_name"] = event.packageName;
      parameterbody["purchase_token"] = event.purchaseToken;
      parameterbody["google_order_id"] = event.googleorderid;

    }
    //IF TOPUP
    if (event.isTopup == true) {
        parameterbody["iccid"] = event.iccid;
    }
    try {
      final response = await apiService.post(
        ApiEndPoints.PAYMENTVERIFY,
        data: parameterbody,
      );
      return PaymentVerifyModel.fromJson(response);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to fetch _onPaymentVerified';
    } catch (e) {
      throw 'Unknown error occurred';
    }
  }

  @override
  ApiState<PaymentVerifyModel> loadingState() => ApiLoading();

  @override
  ApiState<PaymentVerifyModel> successState(PaymentVerifyModel response) =>
      ApiSuccess(response);

  @override
  ApiState<PaymentVerifyModel> errorState(String error) => ApiFailure(error);
}
