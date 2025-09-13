import 'package:esimtel/core/bloc/api_event.dart';

class RegionsDetailsEvent extends ApiEvent {
  final String? regionId;
  String? url;
  final bool? isUnlimited;
  final bool? dataPack;
  final bool? isLowToHigh;
  final bool? isHighToLow;

  RegionsDetailsEvent({
    this.regionId,
    this.url,
    this.isUnlimited,
    this.dataPack,
    this.isLowToHigh,
    this.isHighToLow,
  });
}
