import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:esimtel/utills/UserService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import 'package:esimtel/views/authModule/login_bloc/LoginUser.dart';
import 'package:esimtel/views/authModule/model/usermodel.dart';

class LoginBloc extends ApiBloc<LoginUser, ApiState<LoginModel>, LoginModel> {
  final ApiService apiService;

  LoginBloc(this.apiService) : super(ApiInitial()) {
    on<LoginUser>(_onLoginUser);
  }

  Future<void> _onLoginUser(
    LoginUser event,
    Emitter<ApiState<LoginModel>> emit,
  ) async {
    debugPrint('🚀 LoginUser event triggered loadingState');
    emit(loadingState());
    try {
      final users = await executeApiCall(event);
      emit(successState(users));
    } catch (e) {
      emit(errorState(e.toString()));
    }
  }

  @override
  Future<LoginModel> executeApiCall(LoginUser event) async {
    try {
      // Add referral code if available
      final referralCode = UserService.to.referralCode;

      log('Loginbloc ref code find is $referralCode');
      final Map<String, dynamic> requestData = {'email': event.email};
      if (referralCode != null && referralCode.isNotEmpty) {
        requestData['refCode'] = referralCode;
      }
      log("login Body data email ${event.email}");
      final response = await apiService.post(
        ApiEndPoints.LOGIN,
        data: requestData,
      );
      log('login response is $response');
      return LoginModel.fromJson(response);
    } catch (e) {
      log('❌ Login failed with error: $e');
      throw e is DioException
          ? e.message ?? 'Failed to Login users'
          : 'Unknown error occurred';
    }
  }

  @override
  ApiState<LoginModel> loadingState() => ApiLoading();

  @override
  ApiState<LoginModel> successState(LoginModel response) =>
      ApiSuccess(response);

  @override
  ApiState<LoginModel> errorState(String error) => ApiFailure(error);
}
