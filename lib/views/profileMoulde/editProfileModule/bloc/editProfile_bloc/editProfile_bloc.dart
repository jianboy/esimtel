import 'package:dio/dio.dart';
import 'package:esimtel/views/profileMoulde/editProfileModule/bloc/editProfile_bloc/editProfile_event.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/Model/userProfileModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';

class EditProfileBloc
    extends
        ApiBloc<
          EditProfileEvent,
          ApiState<UserProfileModel>,
          UserProfileModel
        > {
  final ApiService apiService;

  EditProfileBloc(this.apiService) : super(ApiInitial()) {
    on<EditProfileEvent>(_onEditProfileEvent);
  }

  Future<void> _onEditProfileEvent(
    EditProfileEvent event,
    Emitter<ApiState<UserProfileModel>> emit,
  ) async {
    debugPrint('🚀 EditProfileEvent triggered loadingState');
    emit(loadingState());
    try {
      final users = await executeApiCall(event);
      emit(successState(users));
    } catch (e) {
      emit(errorState(e.toString()));
    }
  }

  @override
  Future<UserProfileModel> executeApiCall(EditProfileEvent event) async {
    try {
    

      final formData = FormData.fromMap({
        'name': event.name,
        "currencyId": event.currencyId,
        "email": event.email,
        if (event.profileImage != " " &&
            event.profileImage != null &&
            event.profileImage != "")
          'image': await MultipartFile.fromFile(event.profileImage!),
      });

      final response = await apiService.post(
        ApiEndPoints.USERPROFILE,
        data: formData,
      );
      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw e is DioException
          ? e.message ?? 'Failed EditUserProfile'
          : 'Unknown error occurred';
    }
  }

  @override
  ApiState<UserProfileModel> loadingState() => ApiLoading();

  @override
  ApiState<UserProfileModel> successState(UserProfileModel response) =>
      ApiSuccess(response);

  @override
  ApiState<UserProfileModel> errorState(String error) => ApiFailure(error);
}
