import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import '../../model/ordernowModel.dart';
import 'package_datail_event.dart';

class OrderNowBloc
    extends ApiBloc<BuyNowEvent, ApiState<OrderNowModel>, OrderNowModel> {
  final ApiService apiService;

  OrderNowBloc(this.apiService) : super(ApiInitial()) {
    on<BuyNowEvent>(_onPackageDetailsEvent); 
  }

  Future<void> _onPackageDetailsEvent(
    BuyNowEvent event,
    Emitter<ApiState<OrderNowModel>> emit,
  ) async {
    await _onOrderNow(event, emit);
  }

  Future<void> _onOrderNow(
    BuyNowEvent event,
    Emitter<ApiState<OrderNowModel>> emit,
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
  Future<OrderNowModel> executeApiCall(BuyNowEvent event) async {
    try {
      
      Map<String, dynamic> parametermap = {};

      if (event.isTopu == true) {
        parametermap["iccid"] = event.topUpiccid;
        parametermap["esim_package_id"] = event.packageid;
      } else {
        parametermap["esim_package_id"] = event.packageid;
      }
      final response = await apiService.post(
        ApiEndPoints.ORDERS,
        data: parametermap,
      );
      return OrderNowModel.fromJson(response);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to fetch countries';
    } catch (e) {
      throw 'Unknown error occurred';
    }
  }

  @override
  ApiState<OrderNowModel> loadingState() => ApiLoading();

  @override
  ApiState<OrderNowModel> successState(OrderNowModel response) =>
      ApiSuccess(response);

  @override
  ApiState<OrderNowModel> errorState(String error) => ApiFailure(error);
}
