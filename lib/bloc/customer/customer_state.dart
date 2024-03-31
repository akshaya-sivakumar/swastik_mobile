part of 'customer_bloc.dart';

abstract class CustomerState {}

class CustomerInitial extends CustomerState {}

class CustomerLoad extends CustomerState {}

class CustomerDone extends CustomerState {
  final List<CustomerModel> customers;

  CustomerDone(this.customers);
}

class EnquiryDone extends CustomerState {
  final EnquiryModel enquiry;

  EnquiryDone(this.enquiry);
}

class FollowupDone extends CustomerState {
  final FollowupModel followups;

  FollowupDone(this.followups);
}

class CustomerError extends CustomerState {
  final String message;
  CustomerError(this.message);
}

class CheckinLoad extends CustomerState {}

class CheckinDone extends CustomerState {
  CheckinDone();
}

class CheckinError extends CustomerState {
  final String errorMessage;

  CheckinError({required this.errorMessage});
}

class ProductsLoad extends CustomerState {}

class ProductsDone extends CustomerState {
  final ProductlistModel products;

  ProductsDone(this.products);
}

class ProductsError extends CustomerState {}
