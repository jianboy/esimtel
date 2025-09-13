import 'package:dio/dio.dart';
import 'package:esimtel/views/packageModule/regionsList/model/regionDetailsModel.dart';
import 'package:esimtel/views/packageModule/regionsList/regionDetail_bloc/regionDetails_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';

class RegionDatailsBloc
    extends
        ApiBloc<
          RegionsDetailsEvent,
          ApiState<RegionDetailsModel>,
          RegionDetailsModel
        > {
  final ApiService apiService;

  RegionDatailsBloc(this.apiService) : super(ApiInitial()) {
    on<RegionsDetailsEvent>(_onFetchRegionsList);
  }

  Future<void> _onFetchRegionsList(
    RegionsDetailsEvent event,
    Emitter<ApiState<RegionDetailsModel>> emit,
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
  Future<RegionDetailsModel> executeApiCall(RegionsDetailsEvent event) async {
    final url = event.url ?? ApiEndPoints.PACKAGELIST;
    Map<String, dynamic> parameterbody = {"region_id": event.regionId};
    if (event.isUnlimited != false) {
      parameterbody["is_unlimited"] = event.isUnlimited == true ? '1' : '0';
    }
    if (event.dataPack != false) {
      parameterbody["data_pack"] = event.dataPack == true ? '1' : '0';
    }
    if (event.isHighToLow != false) {
      parameterbody["sort_price"] = event.isHighToLow == true ? 'high' : '';
    }
    if (event.isLowToHigh != false) {
      parameterbody["sort_price"] = event.isLowToHigh == true ? 'low' : '';
    }
    try {
      final response = await apiService.get(url, query: parameterbody);
      return RegionDetailsModel.fromJson(response);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to fetch Regions';
    } catch (e) {
      throw 'Unknown error occurred';
    }
  }

  @override
  ApiState<RegionDetailsModel> loadingState() => ApiLoading();

  @override
  ApiState<RegionDetailsModel> successState(RegionDetailsModel response) =>
      ApiSuccess(response);

  @override
  ApiState<RegionDetailsModel> errorState(String error) => ApiFailure(error);
}
