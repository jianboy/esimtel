import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import 'package:esimtel/views/packageModule/packagesList/bloc/package_detail_bloc/package_datail_event.dart';
import 'package:esimtel/views/packageModule/packagesList/model/packageDetailsModel.dart';

class PackageDetailsBloc
    extends
        ApiBloc<
          PackageDetailsEvent,
          ApiState<PackageDetailsModel>,
          PackageDetailsModel
        > {
  final ApiService apiService;

  PackageDetailsBloc(this.apiService) : super(ApiInitial()) {
    on<PackageDetailsEvent>(_onPackageDetailsEvent);
  }

  Future<void> _onPackageDetailsEvent(
    PackageDetailsEvent event,
    Emitter<ApiState<PackageDetailsModel>> emit,
  ) async {
    await _onFetchPackageDetailsById(event, emit);
  }

  Future<void> _onFetchPackageDetailsById(
    PackageDetailsEvent event,
    Emitter<ApiState<PackageDetailsModel>> emit,
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
  Future<PackageDetailsModel> executeApiCall(PackageDetailsEvent event) async {
    try {
      final response = await apiService.get(
        "${ApiEndPoints.PACKAGE_DETAILS}/${event.packageId}",
      );
      return PackageDetailsModel.fromJson(response);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to fetch countries';
    } catch (e) {
      throw 'Unknown error occurred';
    }
  }

  @override
  ApiState<PackageDetailsModel> loadingState() => ApiLoading();

  @override
  ApiState<PackageDetailsModel> successState(PackageDetailsModel response) =>
      ApiSuccess(response);

  @override
  ApiState<PackageDetailsModel> errorState(String error) => ApiFailure(error);
}
