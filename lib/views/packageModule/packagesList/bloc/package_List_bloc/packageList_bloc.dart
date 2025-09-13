
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import 'package:esimtel/views/packageModule/packagesList/bloc/package_List_bloc/packageList_event.dart';
import 'package:esimtel/views/packageModule/packagesList/model/packageListModel.dart';

class PackagelistBloc
    extends
        ApiBloc<
          PackagelistEvent,
          ApiState<PackagesListModel>,
          PackagesListModel
        > {
  final ApiService apiService;

  PackagelistBloc(this.apiService) : super(ApiInitial()) {
    on<PackagelistEvent>(_onFetchPackageList);
  }

  Future<void> _onFetchPackageList(
    PackagelistEvent event,
    Emitter<ApiState<PackagesListModel>> emit,
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
  Future<PackagesListModel> executeApiCall(PackagelistEvent event) async {
    try {
      final url = event.url ?? ApiEndPoints.PACKAGELIST;
      Map<String, dynamic> parameterbody = {"country": event.countrycode};
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

      final response = await apiService.get(url, query: parameterbody);
      return PackagesListModel.fromJson(response);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to fetch countries';
    } catch (e) {
      throw 'Unknown error occurred';
    }
  }

  @override
  ApiState<PackagesListModel> loadingState() => ApiLoading();

  @override
  ApiState<PackagesListModel> successState(PackagesListModel response) =>
      ApiSuccess(response);

  @override
  ApiState<PackagesListModel> errorState(String error) => ApiFailure(error);
}
