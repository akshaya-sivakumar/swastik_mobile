import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:swastik_mobile/model/checkin_start_req.dart';
import 'package:swastik_mobile/model/kms_model.dart';
import 'package:swastik_mobile/model/visits_model.dart';
import 'package:swastik_mobile/resources/api_base_helper.dart';

class AddkmsRepository {
  Future<Response> addExpense(String kms, File photo, bool start) async {
    FileObject? file;
    file = FileObject('InFile', [photo.path]);
    var response = await ApiBaseHelper().postMultipartFormFile(
        "/KiloMeter/${start ? "start" : "end"}",
        {
          "Id": "00000000-0000-0000-0000-000000000000",
          "Date": DateTime.now().toString(),
          "CreatedBy": "00000000-0000-0000-0000-000000000000",
          "CreatedOn": DateTime.now().toString(),
          if (start)
            "StartKiloMeter": int.tryParse(kms) ?? 0
          else
            "EndKiloMeter": int.tryParse(kms) ?? 0
        },
        file);

    return response;
  }

  Future<FetchkmsModel> getKms() async {
    var response = await ApiBaseHelper().getMethod("/KiloMeter/user");

    FetchkmsModel kms = FetchkmsModel.fromJson(json.decode(response.body));

    return kms;
  }

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
