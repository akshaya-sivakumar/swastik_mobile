part of 'customer_bloc.dart';

abstract class CustomerEvent {}

class FetchCustomer extends CustomerEvent {
  FetchCustomer();
}

class CheckinEvent extends CustomerEvent {
  final CheckinModel checkinModel;
  final File file;
  CheckinEvent(this.checkinModel, this.file);
}

class CheckoutEvent extends CustomerEvent {
  final CheckoutModel checkoutModel;
  final File file;
  CheckoutEvent(this.checkoutModel, this.file);
}

class FetchEnquiry extends CustomerEvent {
  final String fromdate;
  final String todate;
  FetchEnquiry(this.fromdate, this.todate);
}

class FetchFollowup extends CustomerEvent {
  FetchFollowup();
}

class GetProducts extends CustomerEvent {
  GetProducts();
}
