import 'package:equatable/equatable.dart';

abstract class ApiState<T> extends Equatable {
  final T? data;
  final String? error;

  const ApiState({this.data, this.error});

  @override
  List<Object?> get props => [data, error];
}

class ApiInitial<T> extends ApiState<T> {
  const ApiInitial() : super();
}

class ApiLoading<T> extends ApiState<T> {
  const ApiLoading() : super();
}

class ApiSuccess<T> extends ApiState<T> {
  const ApiSuccess(T data) : super(data: data);
}

class ApiFailure<T> extends ApiState<T> {
  const ApiFailure(String error) : super(error: error);
}
