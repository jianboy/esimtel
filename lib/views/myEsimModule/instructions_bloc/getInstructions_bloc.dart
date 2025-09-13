import 'package:dio/dio.dart';
import 'package:esimtel/views/myEsimModule/instructions_bloc/getInstructions_event.dart';
import 'package:esimtel/views/myEsimModule/model/getInstructionsModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/core/bloc/api_bloc.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/api_end_points.dart';
import 'package:esimtel/utills/services/ApiService.dart';

class GetESimInstructionsBloc
    extends
        ApiBloc<
          GetESimInstructionsEvent,
          ApiState<ESimInstructionsModel>,
          ESimInstructionsModel
        > {
  final ApiService apiService;

  GetESimInstructionsBloc(this.apiService) : super(ApiInitial()) {
    on<GetESimInstructionsEvent>(_onfetchEsimInstructions);
  }

  Future<void> _onfetchEsimInstructions(
    GetESimInstructionsEvent event,
    Emitter<ApiState<ESimInstructionsModel>> emit,
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
  Future<ESimInstructionsModel> executeApiCall(
    GetESimInstructionsEvent event,
  ) async {
    try {
      final response = await apiService.get(
        ApiEndPoints.GETESIM_INSTRUCTIONS,
        query: {"iccid": event.icicId},
      );
      return ESimInstructionsModel.fromJson(response);
    } on DioException catch (e) {
      throw e.message ?? 'Failed to fetch Intstructions';
    } catch (e) {
      throw 'Unknown error occurred ${e.toString()}';
    }
  }

  @override
  ApiState<ESimInstructionsModel> loadingState() => ApiLoading();

  @override
  ApiState<ESimInstructionsModel> successState(
    ESimInstructionsModel response,
  ) => ApiSuccess(response);

  @override
  ApiState<ESimInstructionsModel> errorState(String error) => ApiFailure(error);
}
