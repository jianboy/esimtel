import 'package:dio/dio.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/bloc/raiseticket_bloc/raiseticket_event.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/model/raiseTicketModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';

class RaiseTicketsBloc
    extends
        ApiBloc<
          RaiseTicketEvent,
          ApiState<RaiseTicketModel>,
          RaiseTicketModel
        > {
  final ApiService apiService;

  RaiseTicketsBloc(this.apiService) : super(ApiInitial()) {
    on<RaiseTicketEvent>(_onFetchTickets);
  }

  Future<void> _onFetchTickets(
    RaiseTicketEvent event,
    Emitter<ApiState<RaiseTicketModel>> emit,
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
  Future<RaiseTicketModel> executeApiCall(RaiseTicketEvent event) async {
    try {
      final Map<String, dynamic> data = {
        "subject": event.title,
        "message": event.subTitle,
      };
      String url = ApiEndPoints.GET_TICKETS;
      if (event.isfirsttimechat == false) {
        url = '$url/${event.ticketid}/messages';
      }
      final response = await apiService.post(url, data: data);
      return RaiseTicketModel.fromJson(response);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to get ticketsList';
    } catch (e) {
      throw 'Unknown error occurred';
    }
  }

  @override
  ApiState<RaiseTicketModel> loadingState() => ApiLoading();

  @override
  ApiState<RaiseTicketModel> successState(RaiseTicketModel response) =>
      ApiSuccess(response);

  @override
  ApiState<RaiseTicketModel> errorState(String error) => ApiFailure(error);
}
