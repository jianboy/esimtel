import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import 'package:esimtel/views/topUpModule/model/topupmodel.dart';
import 'package:esimtel/views/topUpModule/topup_bloc/topupfeatchevent.dart';

class TopUpBloc
    extends ApiBloc<TopUpFetchEvent, ApiState<TopUpOption>, TopUpOption> {
  final ApiService apiService;

  TopUpBloc(this.apiService) : super(ApiInitial()) {
    on<TopUpFetchEvent>(_onLoginUser);
  }

  Future<void> _onLoginUser(
    TopUpFetchEvent event,
    Emitter<ApiState<TopUpOption>> emit,
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
  Future<TopUpOption> executeApiCall(TopUpFetchEvent event) async {
    Map<String, dynamic> parameterbody = {'type': 'topup', 'iccid': event.ccid};
    try {
      final url = event.url ?? ApiEndPoints.PACKAGELIST;
      final response = await apiService.get(url, query: parameterbody);
      return TopUpOption.fromJson(response);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to TopUpBloc users due to network error.';
    } catch (e) {
      throw 'Failed to parse TopUpOption response. Data format may be incorrect.';
    }
  }

  @override
  ApiState<TopUpOption> loadingState() => ApiLoading();

  @override
  ApiState<TopUpOption> successState(TopUpOption response) =>
      ApiSuccess(response);

  @override
  ApiState<TopUpOption> errorState(String error) => ApiFailure(error);
}
