import 'package:esimtel/core/bloc/api_event.dart';

class fetchNotiEvent extends ApiEvent {
  final String? isAllread;
  final String? url;
  const fetchNotiEvent({this.isAllread, this.url});
}
