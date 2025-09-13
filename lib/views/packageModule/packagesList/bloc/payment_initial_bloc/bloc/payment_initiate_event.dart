import 'package:esimtel/core/bloc/api_event.dart';

class PaymentInitiateEvent extends ApiEvent {
  String amount;
  String currency;
  PaymentInitiateEvent({required this.amount, required this.currency});
}
