import 'package:dio/dio.dart';
import 'package:esimtel/views/homeModule/datapackModule/bloc/datapack_event.dart';
import 'package:esimtel/views/homeModule/datapackModule/model/datapackModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';

class DataPackBloc
    extends ApiBloc<DatapackEvent, ApiState<DataPackModel>, DataPackModel> {
  final ApiService apiService;

  DataPackBloc(this.apiService) : super(ApiInitial()) {
    on<DatapackEvent>(_onFetchRegionsList);
  }

  Future<void> _onFetchRegionsList(
    DatapackEvent event,
    Emitter<ApiState<DataPackModel>> emit,
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
  Future<DataPackModel> executeApiCall(DatapackEvent event) async {
    Map<String, dynamic> parameterbody = event.isdatapack
        ? {"data_pack": true, "sort_price": 'low'}
        : {"text_voice": true, "sort_price": 'low'};
    try {
      final response = await apiService.get(
        ApiEndPoints.PACKAGELIST,
        query: parameterbody,
      );
      return DataPackModel.fromJson(response);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to fetch Regions';
    } catch (e) {
      throw 'Unknown error occurred';
    }
  }

  @override
  ApiState<DataPackModel> loadingState() => ApiLoading();

  @override
  ApiState<DataPackModel> successState(DataPackModel response) =>
      ApiSuccess(response);

  @override
  ApiState<DataPackModel> errorState(String error) => ApiFailure(error);
}
