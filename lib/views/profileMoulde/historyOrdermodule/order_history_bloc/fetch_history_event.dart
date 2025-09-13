import 'package:esimtel/core/bloc/api_event.dart';

class fetchOrderhistoryEvent extends ApiEvent {
  final String? url;
  const fetchOrderhistoryEvent({this.url});
}
