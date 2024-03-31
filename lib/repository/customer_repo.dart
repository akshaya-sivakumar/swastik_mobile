import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:http/http.dart';
import 'package:swastik_mobile/model/checkin_model.dart';
import 'package:swastik_mobile/model/checkout_model.dart';
import 'package:swastik_mobile/model/customer_model.dart';
import 'package:swastik_mobile/model/enquiry_model.dart';
import 'package:swastik_mobile/model/followup_model.dart';
import 'package:swastik_mobile/model/productlist_model.dart';

import '../resources/api_base_helper.dart';

class CustomerRepository {
  Future<List<CustomerModel>> getCustomers() async {
    var response = await ApiBaseHelper().getMethod("/Customer");

    List<CustomerModel> maincategoryResponse = List.from(json
        .decode(response.body)["item"]
        .map((e) => CustomerModel.fromJson(e)));

    return maincategoryResponse;
  }

  Future<Response> checkin(CheckinModel request, File photo) async {
    FileObject? file;
    file = FileObject('InFile', [photo.path]);
    var response = await ApiBaseHelper()
        .postMultipartFormFile("/Enquiry/checkIn", request.toJson(), file);

    return response;
  }

  Future<Response> checkout(CheckoutModel request, File photo) async {
    FileObject? file;
    file = FileObject('OutFile', [photo.path]);
    var response = await ApiBaseHelper()
        .postMultipartFormFile("/Enquiry/checkOut", request.toJson(), file);

    return response;
  }

  Future<EnquiryModel> getEnquiry(String fromdate, String todate) async {
    var response =
        await ApiBaseHelper().getMethod("/Enquiry/$fromdate/$todate");

    EnquiryModel maincategoryResponse =
        EnquiryModel.fromJson(jsonDecode(response.body));

    return maincategoryResponse;
  }

  Future<FollowupModel> followup() async {
    var response = await ApiBaseHelper().getMethod("/Enquiry/followup");

    FollowupModel maincategoryResponse =
        FollowupModel.fromJson(jsonDecode(response.body));

    return maincategoryResponse;
  }

  Future<ProductlistModel> product() async {
    var response = await ApiBaseHelper().getMethod("/Enquiry/products");

    ProductlistModel maincategoryResponse =
        ProductlistModel.fromJson(jsonDecode(response.body));

    return maincategoryResponse;
  }
}
