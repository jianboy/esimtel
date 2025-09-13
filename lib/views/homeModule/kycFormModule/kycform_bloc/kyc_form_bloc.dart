import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import 'package:esimtel/views/homeModule/kycFormModule/kycform_bloc/kycformevent.dart';
import 'package:esimtel/views/homeModule/kycFormModule/model/KYCResponse.dart';
import 'package:esimtel/utills/global.dart' as global;

class KycFormBloc
    extends ApiBloc<KycFormEvent, ApiState<KYCResponse>, KYCResponse> {
  final ApiService apiService;
  KycFormBloc(this.apiService) : super(ApiInitial()) {
    on<KycFormEvent>(_onKycFormEvent);
  }
  Future<void> _onKycFormEvent(
    KycFormEvent event,
    Emitter<ApiState<KYCResponse>> emit,
  ) async {
    emit(loadingState());
    try {
      final users = await executeApiCall(event);
      emit(successState(users));
    } catch (e) {
      emit(errorState(e.toString()));
    }
  }

  @override
  Future<KYCResponse> executeApiCall(KycFormEvent event) async {
    try {
      final formData = FormData.fromMap({
        'full_name': event.fullname,
        "dob": event.dob,
        "address": event.address,
        "identity_card_no": event.icardno,
        "identity_card": await MultipartFile.fromFile(event.identitycard),
        "pancard": await MultipartFile.fromFile(event.pancard),
        "photo": await MultipartFile.fromFile(event.photo),
      });

      final response = await apiService.post(
        ApiEndPoints.KYCFORM,
        data: formData,
      );
      return KYCResponse.fromJson(response);
    } on DioException catch (e) {
      global.showToastMessage(message: '${e.error}');
      throw e.message ??
          'Failed to complete the request due to a network error.';
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  ApiState<KYCResponse> loadingState() => ApiLoading();

  @override
  ApiState<KYCResponse> successState(KYCResponse response) =>
      ApiSuccess(response);

  @override
  ApiState<KYCResponse> errorState(String error) => ApiFailure(error);
}
