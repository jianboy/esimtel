import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import '../Model/deleteAccount_model.dart';
import 'deleteAccount_event.dart';

class DeleteAccountBloc
    extends ApiBloc<DeleteAccountEvent, ApiState<DeleteModel>, DeleteModel> {
  final ApiService apiService;

  DeleteAccountBloc(this.apiService) : super(ApiInitial()) {
    on<DeleteAccountEvent>(_onFetchPackageList);
  }

  Future<void> _onFetchPackageList(
    DeleteAccountEvent event,
    Emitter<ApiState<DeleteModel>> emit,
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
  Future<DeleteModel> executeApiCall(DeleteAccountEvent event) async {
    try {
      final response = await apiService.get(ApiEndPoints.DELETE_ACCOUNT);
      return DeleteModel.fromJson(response);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to delete account';
    } catch (e) {
      throw 'Unknown error occurred';
    }
  }

  @override
  ApiState<DeleteModel> loadingState() => ApiLoading();

  @override
  ApiState<DeleteModel> successState(DeleteModel response) =>
      ApiSuccess(response);

  @override
  ApiState<DeleteModel> errorState(String error) => ApiFailure(error);
}
