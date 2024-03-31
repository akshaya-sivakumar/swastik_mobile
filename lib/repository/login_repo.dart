import 'dart:convert';
import 'dart:core';

import 'package:swastik_mobile/model/login_request.dart';
import 'package:swastik_mobile/model/login_response.dart';

import '../resources/api_base_helper.dart';

class LoginRepository {
  Future<LoginResponse> data(LoginRequest request) async {
    print(json.encode(request));
    var response = await ApiBaseHelper().postMethod(
      "/Authenticate/login",
      json.encode(request),
    );

    print(response.body);

    return LoginResponse.fromJson(json.decode(response.body));
  }
}
