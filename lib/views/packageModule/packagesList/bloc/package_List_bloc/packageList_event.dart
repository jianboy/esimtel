import 'package:esimtel/core/bloc/api_event.dart';
class PackagelistEvent extends ApiEvent {
  final String? countrycode;
  final String? url;
  final bool? isUnlimited;
  final bool? dataPack;
   final bool? isLowToHigh;
  final bool? isHighToLow;

  const PackagelistEvent({
    this.countrycode,
    this.url,
    this.isUnlimited,
    this.dataPack,
    this.isLowToHigh,
    this.isHighToLow,
  });
}
