import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import '../model/order_history_model.dart';
import 'fetch_history_event.dart';

class FetchOrderHistorybloc
    extends
        ApiBloc<
          fetchOrderhistoryEvent,
          ApiState<OrderHistoryModel>,
          OrderHistoryModel
        > {
  final ApiService apiService;

  FetchOrderHistorybloc(this.apiService) : super(ApiInitial()) {
    on<fetchOrderhistoryEvent>(_onFetchOrderList);
  }

  Future<void> _onFetchOrderList(
    fetchOrderhistoryEvent event,
    Emitter<ApiState<OrderHistoryModel>> emit,
  ) async {
    if (event.url == null) {
      emit(loadingState());
    }

    try {
      final result = await executeApiCall(event);
      emit(successState(result));
    } catch (e) {
      if (event.url == null) {
        emit(errorState(e.toString()));
      } else {
        log('Pagination API call failed: $e');
      }
    }
  }

  @override
  Future<OrderHistoryModel> executeApiCall(fetchOrderhistoryEvent event) async {
    try {
      final url = event.url ?? ApiEndPoints.ORDERS;

      final response = await apiService.get(url);
      return OrderHistoryModel.fromJson(response);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to fetch OrderList';
    } catch (e) {
      throw 'Unknown error occurred';
    }
  }

  @override
  ApiState<OrderHistoryModel> loadingState() => ApiLoading();

  @override
  ApiState<OrderHistoryModel> successState(OrderHistoryModel response) =>
      ApiSuccess(response);

  @override
  ApiState<OrderHistoryModel> errorState(String error) => ApiFailure(error);
}
