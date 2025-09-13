import 'package:dio/dio.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/bloc/tickets_bloc/ticket_event.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/model/ticketModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';

class TicketsBloc
    extends ApiBloc<TicketEvent, ApiState<TicketsModel>, TicketsModel> {
  final ApiService apiService;

  TicketsBloc(this.apiService) : super(ApiInitial()) {
    on<TicketEvent>(_onFetchTickets);
  }

  Future<void> _onFetchTickets(
    TicketEvent event,
    Emitter<ApiState<TicketsModel>> emit,
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
  Future<TicketsModel> executeApiCall(TicketEvent event) async {
    try {
      final response = await apiService.get(ApiEndPoints.GET_TICKETS);
      return TicketsModel.fromJson(response);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to get ticketsList';
    } catch (e) {
      throw 'Unknown error occurred';
    }
  }

  @override
  ApiState<TicketsModel> loadingState() => ApiLoading();

  @override
  ApiState<TicketsModel> successState(TicketsModel response) =>
      ApiSuccess(response);

  @override
  ApiState<TicketsModel> errorState(String error) => ApiFailure(error);
}
