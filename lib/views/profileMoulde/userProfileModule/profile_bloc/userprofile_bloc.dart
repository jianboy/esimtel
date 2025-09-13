import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/profile_bloc/userprofile_event.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/Model/userProfileModel.dart';

import '../../../../utills/connectivity/connectivity_bloc.dart';

class UserProfileBloc
    extends
        ApiBloc<
          UserProfileEvent,
          ApiState<UserProfileModel>,
          UserProfileModel
        > {
  final ApiService apiService;
  final ConnectivityBloc _connectivityBloc;
  late StreamSubscription connectivitySubscription;
  UserProfileBloc(this.apiService, this._connectivityBloc)
    : super(ApiInitial()) {
    on<UserProfileEvent>(_onFetchPackageList);

    connectivitySubscription = _connectivityBloc.stream.listen((state) {
      if (state is Connected) {
        add(UserProfileEvent());
      }
    });
  }

  Future<void> _onFetchPackageList(
    UserProfileEvent event,
    Emitter<ApiState<UserProfileModel>> emit,
  ) async {
    emit(loadingState());
    try {
      final result = await executeApiCall(event);
      emit(successState(result));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        emit(errorState("No internet connection."));
      } else {
        emit(errorState(e.message ?? 'Failed to fetch data'));
      }
    } catch (e) {
      emit(errorState(e.toString()));
    }
  }

  @override
  Future<UserProfileModel> executeApiCall(UserProfileEvent event) async {
    final response = await apiService.get(ApiEndPoints.USERPROFILE);
    return UserProfileModel.fromJson(response);
  }

  @override
  ApiState<UserProfileModel> loadingState() => ApiLoading();

  @override
  ApiState<UserProfileModel> successState(UserProfileModel response) =>
      ApiSuccess(response);

  @override
  ApiState<UserProfileModel> errorState(String error) => ApiFailure(error);
}
