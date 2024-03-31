import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:swastik_mobile/model/checkin_start_req.dart';

import 'package:swastik_mobile/model/visits_model.dart';
import 'package:swastik_mobile/resources/api_base_helper.dart';

class AddkmsRepository {
 

  Future<VisitsModel> getVisits() async {
    var response = await ApiBaseHelper().getMethod("/DailyVisit/visits");

    VisitsModel visits = VisitsModel.fromJson(json.decode(response.body));

    return visits;
  }

  Future<Response> addVisits(
      CheckinstartModel checkinstartModel, bool checkin) async {
    var response = await ApiBaseHelper().postMethod(
        checkin ? "/DailyVisit/checkIn" : "/DailyVisit/checkOut",
        json.encode(checkinstartModel.toJson()));

    return response;
  }
}
