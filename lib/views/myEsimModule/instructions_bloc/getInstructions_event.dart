import 'package:esimtel/core/bloc/api_event.dart';

class GetESimInstructionsEvent extends ApiEvent {
  final String icicId;
  const GetESimInstructionsEvent({required this.icicId});
}
