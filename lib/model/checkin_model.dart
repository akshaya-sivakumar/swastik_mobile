class CheckinModel {
  CheckinModel(
      {this.id,
      this.date,
      this.customerId,
      this.companyName,
      this.address,
      this.emailId,
      this.contactPersonName,
      this.contactPersonPhone,
      this.district,
      this.city,
      this.customerAddress,
      this.inLatitude,
      this.inLongitude,
      this.inTime,
      this.createdBy,
      this.inPhotoUrl,
      this.createdOn,
      this.hasNextFolloup,
      this.nextFollowupDate,
      this.meetingPoints,
      this.landLineNumber,
      this.officePhoneNumber,
      this.isNewCustomer = true});
  String? id;
  String? date;
  String? customerId;
  String? companyName;
  String? address;
  String? emailId;
  String? contactPersonName;
  String? contactPersonPhone;
  String? district;
  String? city;
  String? inLongitude;
  String? inLatitude;
  String? inTime;
  String? createdBy;
  String? customerAddress;
  String? inPhotoUrl;
  String? createdOn;
  String? meetingPoints;
  String? hasNextFolloup;
  String? nextFollowupDate;
  String? officePhoneNumber;
  String? landLineNumber;

  bool isNewCustomer = true;

  CheckinModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    date = json["Date"];
    customerId = json['CustomerId'];
    companyName = json['CompanyName'];
    address = json['Address'];
    emailId = json['EmailId'];
    contactPersonName = json['ContactPersonName'];
    contactPersonPhone = json['ContactPersonPhone'];
    district = json['District'];
    city = json['City'];
    inLongitude = json['InLongitude'];
    inLatitude = json['InLatitude'];
    inTime = json['InTime'];
    isNewCustomer = json['IsNewCustomer'] ?? true;
    createdBy = json["CreatedBy"];
    customerAddress = json["CustomerAddress"];
    inPhotoUrl = json["InPhotoUrl"];
    createdOn = json["CreatedOn"];
    meetingPoints = json["MeetingPoints"] ?? "";
    hasNextFolloup = json["HasNextFolloup"];
    nextFollowupDate = json["NextFollowupDate"];
    officePhoneNumber = json["OfficePhoneNumber"];
    landLineNumber = json["LandLineNumber"];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['Id'] = id ?? "00000000-0000-0000-0000-000000000000";
    datas["Date"] = inTime ?? "";
    datas['CustomerId'] = customerId ?? "00000000-0000-0000-0000-000000000000";
    datas['CompanyName'] = companyName ?? "no";
    datas['Address'] = address ?? "no";
    datas['EmailId'] = emailId ?? "no";
    datas['ContactPersonName'] = contactPersonName ?? "no";
    datas['ContactPersonPhone'] = contactPersonPhone ?? "no";
    datas['District'] = district ?? "no";
    datas['City'] = city ?? "no";
    datas['InLongitude'] = inLongitude ?? "0";
    datas['InLatitude'] = inLatitude ?? "0";
    datas['InTime'] = inTime ?? "";
    datas['IsNewCustomer'] = isNewCustomer;
    datas["CreatedBy"] = createdBy ?? "00000000-0000-0000-0000-000000000000";
    datas["CustomerAddress"] = customerAddress ?? "no";
    datas["InPhotoUrl"] = inPhotoUrl ?? "no";
    datas["CreatedOn"] = inTime ?? "no";
    datas["MeetingPoints"] = meetingPoints ?? "no";
    datas["HasNextFolloup"] = false;
    datas["NextFollowupDate"] = inTime;
    datas["LandLineNumber"] = landLineNumber ?? "no";
    datas["OfficePhoneNumber"] = officePhoneNumber ?? "no";
    return datas;
  }
}
