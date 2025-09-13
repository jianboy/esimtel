import 'package:esimtel/core/bloc/api_event.dart';

class KycFormEvent extends ApiEvent {
  final String fullname;
  final String dob;
  final String address;
  final String identitycard;
  final String pancard;
  final String photo;
  final String icardno;
  const KycFormEvent({
    required this.fullname,
    required this.dob,
    required this.address,
    required this.identitycard,
    required this.pancard,
    required this.photo,
    required this.icardno,
  });
}
