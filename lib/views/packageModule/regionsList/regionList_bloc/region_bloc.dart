
import 'package:dio/dio.dart';
import 'package:esimtel/views/packageModule/regionsList/regionList_bloc/region_event.dart';
import 'package:esimtel/views/packageModule/regionsList/model/regionsModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';

class RegionsListBloc
    extends ApiBloc<RegionsListEvent, ApiState<RegionsModel>, RegionsModel> {
  final ApiService apiService;

  RegionsListBloc(this.apiService) : super(ApiInitial()) {
    on<RegionsListEvent>(_onFetchRegionsList);
  }

  Future<void> _onFetchRegionsList(
    RegionsListEvent event,
    Emitter<ApiState<RegionsModel>> emit,
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
  Future<RegionsModel> executeApiCall(RegionsListEvent event) async {
    try {
      final response = await apiService.get(ApiEndPoints.REGIONS);
      return RegionsModel.fromJson(response);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to fetch Regions';
    } catch (e) {
      throw 'Unknown error occurred';
    }
  }

  @override
  ApiState<RegionsModel> loadingState() => ApiLoading();

  @override
  ApiState<RegionsModel> successState(RegionsModel response) =>
      ApiSuccess(response);

  @override
  ApiState<RegionsModel> errorState(String error) => ApiFailure(error);
}
