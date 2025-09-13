import 'package:esimtel/core/bloc/api_event.dart';

class DatapackEvent extends ApiEvent {
  final bool isdatapack;
  const DatapackEvent({
    required this.isdatapack,
  });
}
