import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swastik_mobile/route_generator.dart';
import 'package:swastik_mobile/screen_util/flutter_screenutil.dart';
import 'package:swastik_mobile/ui/widgets/button.dart';
import 'package:swastik_mobile/ui/widgets/text_widget.dart';

class FileObject {
  final String fieldName;
  final List fileNames;

  FileObject(this.fieldName, this.fileNames);
}

class ApiBaseHelper {
  Future<http.Response> postMethod(String url, String request,
      {bool isMultipart = false, FileObject? file}) async {
    print(request);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";

    var response = await http.post(
      Uri.parse("https://swastikapi.rentalsoftware.in/api$url"),
      headers: {
        'Authorization': "Bearer $token",
        /*   "Access-Control-Allow-Origin":
              "http://qa-webdzo-stayz.s3-website.ap-south-1.amazonaws.com", */
        "Content-Type": isMultipart
            ? 'application/x-www-form-urlencoded'
            : 'application/json'
      },
      body: isMultipart ? {"data": request} : request,
    );

    handleResponse(response);
    return response;
  }

  Future<http.Response> putMethod(
    String url,
    String request,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    print(token);
    var response = await http.put(
      Uri.parse("https://swastikapi.rentalsoftware.in/api$url"),
      headers: {
        'Authorization': "Bearer $token",
        /*   "Access-Control-Allow-Origin":
              "http://qa-webdzo-stayz.s3-website.ap-south-1.amazonaws.com", */
        "Content-Type": 'application/json'
      },
      body: request,
    );

    handleResponse(response);
    return response;
  }

  Future<http.Response> deleteMethod(
    String url,
    String request,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    print(token);
    var response = await http.delete(
      Uri.parse("https://swastikapi.rentalsoftware.in/api$url"),
      headers: {
        'Authorization': "Bearer $token",
        "Content-Type": 'application/json'
      },
      body: request,
    );

    handleResponse(response);
    return response;
  }

  void handleResponse(http.Response response) {
    if (response.statusCode != 200) {
      logError(response.request.toString(), response.body);

      if (response.statusCode == 204) {
        throw response.statusCode.toString();
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentContext!,
          builder: (context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextWidget(
                    "Session Expired",
                    fontweight: FontWeight.bold,
                    size: 22.sp,
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextWidget("Please Login again!!"),
                ],
              ),
              actions: [
                button("Login Again", () async {
                  Navigator.pop(navigatorKey.currentContext!);
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.clear();
                  navigatorKey.currentState?.pushNamedAndRemoveUntil(
                    "/",
                    (route) {
                      return false;
                    },
                  );
                }, HexColor("#135a92"))
              ],
            );
          },
        );
        /*   Fluttertoast.showToast(
            msg: "Session exipred",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red.shade900,
            textColor: Colors.white,
            fontSize: 16.0); */
        //throw "Session exipred";
      } else {
        throw Exception(response.body);
      }
    } else {
      if (response.statusCode == 200) {
        logSuccess(response.request.toString(), response.body);
      } else {
        logError(response.request.toString(), response.body);
        throw (json.decode(response.body)["errorMessage"] ?? "");
      }
    }
  }

  Future<http.Response> getMethod(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    print(token);
    var response = await http.get(
        Uri.parse("https://swastikapi.rentalsoftware.in/api$url"),
        headers: {'Authorization': "Bearer $token"});
    handleResponse(response);
    return response;
  }

  Future<Response> postMultipartFormFile(
      String url, Map<dynamic, dynamic> request, FileObject? file) async {
    debugPrint(jsonEncode(request));

    Response responseJson;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";

    Map<String, String> headers = {
      'Authorization': "Bearer $token",
      "Content-Type": 'multipart/form-data'
    };

    var uri = Uri.parse("https://swastikapi.rentalsoftware.in/api$url");

    var multipartRequest = http.MultipartRequest("POST", uri);

    for (var headerKey in headers.keys) {
      multipartRequest.headers[headerKey] = headers[headerKey]!;
    }
    for (var e in request.entries) {
      multipartRequest.fields[e.key] = e.value.toString();
    }

    if (file != null) {
      for (var fileName in file.fileNames) {
        multipartRequest.files.add(http.MultipartFile.fromBytes(
            file.fieldName, await File(fileName).readAsBytes(),
            filename: fileName
                .split("/")
                .last
                .toString()
                .substring(fileName.split("/").last.toString().length - 8)));
      }
    }

    http.StreamedResponse response = await multipartRequest.send();

    responseJson = await (_returnStreamedResponse(response));
    return responseJson;
  }

  Future<dynamic> _returnStreamedResponse(
      http.StreamedResponse response) async {
    debugPrint(response.statusCode.toString());
    debugPrint(response.request!.url.toString());
    String responseData = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      logError(response.request.toString(), response.statusCode);

      if (response.statusCode == 204) {
        throw response.statusCode.toString();
      } else {
        throw Exception(responseData);
      }
    } else {
      if (json.decode(responseData)["isOk"]) {
        logSuccess(response.request.toString(), responseData);
      } else {
        logError(response.request.toString(), responseData);
        throw (json.decode(responseData)["errorMessage"] ?? "Unknown Error");
      }
    }

    return http.Response(responseData, response.statusCode);
  }

  void logSuccess(String logName, dynamic msg) {
    log('\x1B[32m$logName $msg\x1B[0m');
  }

  void logError(String logName, dynamic msg) {
    log('\x1B[31m$logName $msg\x1B[0m');
  }
}
