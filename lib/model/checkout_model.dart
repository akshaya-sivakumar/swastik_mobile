class CheckoutModel {
  CheckoutModel(
      {this.id,
      this.customerId,
      this.contactPersonName,
      this.contactPersonPhone,
      this.outTime,
      this.outPhotoUrl,
      this.outLatitude,
      this.outLongitude,
      this.meetingPoints,
      this.hasNextFolloup = false,
      this.nextFollowupDate,
      this.outFile,
      this.customerEmail,
      this.landLineNumber,
      this.officePhoneNumber,
      this.updatedBy});
  String? id;

  String? customerId;
  String? contactPersonName;
  String? contactPersonPhone;

  String? outTime;
  String? outPhotoUrl;
  double? outLatitude;
  double? outLongitude;
  String? meetingPoints;
  bool? hasNextFolloup;
  String? nextFollowupDate;

  String? outFile;
  String? customerEmail;
  String? officePhoneNumber;
  String? landLineNumber;
  String? updatedBy;
  List<dynamic>? enquiryProducts;

  CheckoutModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";

    customerId = json['CustomerId'] ?? "";
    contactPersonName = json['ContactPersonName'] ?? "";
    contactPersonPhone = json['ContactPersonPhone'] ?? "";
    customerEmail = json["CustomerEmail"] ?? "no";

    outTime = json['outTime'] ?? "";
    outPhotoUrl = json['OutPhotoUrl'];
    outLatitude = json['OutLatitude'];
    outLongitude = json['OutLongitude'];
    meetingPoints = json['MeetingPoints'];
    hasNextFolloup = json['HasNextFolloup'];
    nextFollowupDate = json['NextFollowupDate'];
    officePhoneNumber = json["OfficePhoneNumber"];
    landLineNumber = json["LandLineNumber"];

    updatedBy = json['UpdatedBy'] ?? "";
    enquiryProducts = json["EnquiryProducts"];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['Id'] = id ?? "00000000 - 0000 - 0000 - 0000 - 000000000000";

    datas['CustomerId'] =
        customerId ?? "00000000 - 0000 - 0000 - 0000 - 000000000000";
    datas['ContactPersonName'] = contactPersonName ?? "no";
    datas['ContactPersonPhone'] = contactPersonPhone ?? "no";

    datas['OutTime'] = outTime;
    datas['OutPhotoUrl'] = outPhotoUrl ?? "no";
    datas['OutLatitude'] = outLatitude ?? 0;
    datas['OutLongitude'] = outLongitude ?? 0;
    datas['MeetingPoints'] = meetingPoints ?? "no";
    datas['HasNextFolloup'] = hasNextFolloup ?? false;
    datas['NextFollowupDate'] = nextFollowupDate ?? "";
    datas["CustomerEmail"] = customerEmail ?? "no";
    datas["OfficePhoneNumber"] = officePhoneNumber ?? "no";
    datas["LandLineNumber"] = landLineNumber ?? "no";
    datas["UpdatedBy"] =
        updatedBy ?? "00000000 - 0000 - 0000 - 0000 - 000000000000";
    datas["EnquiryProducts"] = enquiryProducts;
    return datas;
  }
}
