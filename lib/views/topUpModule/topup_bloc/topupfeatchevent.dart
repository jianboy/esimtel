import 'package:esimtel/core/bloc/api_event.dart';

class TopUpFetchEvent extends ApiEvent {
  String? ccid;
  String? url;
  TopUpFetchEvent({required this.ccid, this.url});
}
