import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swastik_mobile/model/checkin_model.dart';
import 'package:swastik_mobile/model/checkout_model.dart';
import 'package:swastik_mobile/model/customer_model.dart';
import 'package:swastik_mobile/model/enquiry_model.dart';
import 'package:swastik_mobile/model/followup_model.dart';
import 'package:swastik_mobile/model/productlist_model.dart';
import 'package:swastik_mobile/repository/customer_repo.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc() : super(CustomerInitial()) {
    on<FetchCustomer>((event, emit) async {
      emit(CustomerLoad());
      try {
        final contacts = await CustomerRepository().getCustomers();

        emit(CustomerDone(contacts));
      } catch (e) {
        emit(CustomerError(e.toString()));
      }
    });

    on<CheckinEvent>((event, emit) async {
      emit(CheckinLoad());
      try {
        final response =
            await CustomerRepository().checkin(event.checkinModel, event.file);

        emit(CheckinDone());
      } catch (e) {
        emit(CheckinError(errorMessage: e.toString()));
      }
    });
    on<CheckoutEvent>((event, emit) async {
      emit(CheckinLoad());
      try {
        final response = await CustomerRepository()
            .checkout(event.checkoutModel, event.file);

        emit(CheckinDone());
      } catch (e) {
        emit(CheckinError(errorMessage: e.toString()));
      }
    });

    on<FetchEnquiry>((event, emit) async {
      emit(CustomerLoad());
      try {
        final contacts =
            await CustomerRepository().getEnquiry(event.fromdate, event.todate);

        emit(EnquiryDone(contacts));
      } catch (e) {
        emit(CustomerError(e.toString()));
      }
    });
    on<FetchFollowup>((event, emit) async {
      emit(CustomerLoad());
      try {
        final contacts = await CustomerRepository().followup();

        emit(FollowupDone(contacts));
      } catch (e) {
        emit(CustomerError(e.toString()));
      }
    });

    on<GetProducts>((event, emit) async {
      emit(ProductsLoad());
      try {
        final contacts = await CustomerRepository().product();

        emit(ProductsDone(contacts));
      } catch (e) {
        emit(ProductsError());
      }
    });
  }
}
