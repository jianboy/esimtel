import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import '../model/paymentinitiateModel.dart';
import 'payment_initiate_event.dart';

class PaymentInitiatebloc
    extends
        ApiBloc<
          PaymentInitiateEvent,
          ApiState<PaymentInitiateModel>,
          PaymentInitiateModel
        > {
  final ApiService apiService;

  PaymentInitiatebloc(this.apiService) : super(ApiInitial()) {
    on<PaymentInitiateEvent>(_onPaymentInitiated);
  }

  Future<void> _onPaymentInitiated(
    PaymentInitiateEvent event,
    Emitter<ApiState<PaymentInitiateModel>> emit,
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
  Future<PaymentInitiateModel> executeApiCall(
    PaymentInitiateEvent event,
  ) async {
    try {
      final response = await apiService.post(
        ApiEndPoints.PAYMENTINITIATE,
        data: {"amount": event.amount, "currency": event.currency},
      );
      return PaymentInitiateModel.fromJson(response);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to fetch _onPaymentInitiated';
    } catch (e) {
      throw 'Unknown error occurred';
    }
  }

  @override
  ApiState<PaymentInitiateModel> loadingState() => ApiLoading();

  @override
  ApiState<PaymentInitiateModel> successState(PaymentInitiateModel response) =>
      ApiSuccess(response);

  @override
  ApiState<PaymentInitiateModel> errorState(String error) => ApiFailure(error);
}
