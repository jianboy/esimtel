import 'package:esimtel/core/bloc/api_event.dart';

class PackageDetailsEvent extends ApiEvent {
  final String? packageId;
  const PackageDetailsEvent({required this.packageId});
}
