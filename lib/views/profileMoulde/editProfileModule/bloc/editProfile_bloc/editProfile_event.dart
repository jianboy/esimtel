import 'package:esimtel/core/bloc/api_event.dart';

class EditProfileEvent extends ApiEvent {
  final String name;
  final String email;
  final String? profileImage;
  final String currencyId;
  const EditProfileEvent({
    required this.name,
    required this.email,
    required this.profileImage,
    required this.currencyId,
  });
}
