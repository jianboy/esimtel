import 'package:dio/dio.dart';
import 'package:esimtel/utills/UserService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import 'package:esimtel/views/authModule/model/verifymodel.dart';
import 'package:esimtel/views/authModule/verify_bloc/VerifyUser.dart';
import '../../../utills/global.dart' as global;

class Verifybloc
    extends ApiBloc<VerifyUser, ApiState<VerifyModel>, VerifyModel> {
  final ApiService apiService;

  Verifybloc(this.apiService) : super(ApiInitial()) {
    on<VerifyUser>(_onVerifyUser);
  }

  Future<void> _onVerifyUser(
    VerifyUser event,
    Emitter<ApiState<VerifyModel>> emit,
  ) async {
    debugPrint('🚀 VerifyUser event triggered loadingState');
    emit(loadingState());
    try {
      final users = await executeApiCall(event);
      emit(successState(users));
    } catch (e) {
      emit(errorState(e.toString()));
    }
  }

  @override
  Future<VerifyModel> executeApiCall(VerifyUser event) async {
    try {
      final deviceDetails = await global.getDeviceDetails();

      final deviceId = deviceDetails['deviceid'];
      final fcmToken = deviceDetails['fcmToken'];
      final location = '';
      final manufacturer = deviceDetails['deviceManufacture'];
      final appVersion = deviceDetails['appVersion'];
      final model = deviceDetails['deviceModel'];
      final referralCode = UserService.to.referralCode;
      final Map<String, dynamic> requestData = {
        'email': event.email,
        'deviceid': deviceId,
        'fcmToken': fcmToken,
        'deviceLocation': location,
        'deviceManufacturer': manufacturer,
        'appVersion': appVersion,
        'deviceModel': model,
      };
      // if reffcode available
      if (referralCode != null && referralCode.isNotEmpty) {
        requestData['refCode'] = referralCode;
      }
      // Conditionally add the 'otp' or 'is_firebase_login' field.
      if (event.isLoginUsingFirebase) {
        requestData['is_firebase_login'] = true;
      } else {
        requestData['otp'] = event.otp;
      }
      final response = await apiService.post(
        ApiEndPoints.VERIFYEMAIL,
        data: requestData,
      );
      return VerifyModel.fromJson(response);
    } catch (e) {
      throw e is DioException
          ? e.message ?? 'Failed to verify users'
          : 'Unknown error occurred';
    }
  }

  @override
  ApiState<VerifyModel> loadingState() => ApiLoading();

  @override
  ApiState<VerifyModel> successState(VerifyModel response) =>
      ApiSuccess(response);

  @override
  ApiState<VerifyModel> errorState(String error) => ApiFailure(error);
}
