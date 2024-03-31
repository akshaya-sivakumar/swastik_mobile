class EnquiryModel {
  EnquiryModel({
    required this.isOk,
    required this.successMessage,
    required this.errorMessage,
    required this.item,
  });
  late final bool isOk;
  late final String successMessage;
  late final String errorMessage;
  late final List<Item> item;

  EnquiryModel.fromJson(Map<String, dynamic> json) {
    isOk = json['isOk'];
    successMessage = json['successMessage'];
    errorMessage = json['errorMessage'] ?? "";
    item = List.from(json['item']).map((e) => Item.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['isOk'] = isOk;
    datas['successMessage'] = successMessage;
    datas['errorMessage'] = errorMessage;
    datas['item'] = item.map((e) => e.toJson()).toList();
    return datas;
  }
}

class Item {
  Item({
    required this.id,
    required this.date,
    required this.dateAsString,
    required this.customerId,
    required this.contactPersonName,
    required this.contactPersonPhone,
    required this.inTime,
    required this.inLatitude,
    required this.inLongitude,
    required this.inPhotoUrl,
    required this.outTime,
    required this.outPhotoUrl,
    required this.outLatitude,
    required this.outLongitude,
    required this.meetingPoints,
    required this.hasNextFolloup,
    required this.nextFollowupDate,
    required this.hasVerified,
    required this.isNewCustomer,
    required this.createdBy,
    required this.createdOn,
    required this.verifiedOn,
    required this.verifiedBy,
    required this.inFile,
    required this.outFile,
    required this.address,
    required this.enquiryNumber,
    required this.code,
    required this.createdByNavigation,
    required this.customer,
    required this.verifiedByNavigation,
  });
  late final String id;
  late final String date;
  late final String dateAsString;
  late final String customerId;
  late final String contactPersonName;
  late final String contactPersonPhone;
  late final String inTime;
  late final double inLatitude;
  late final double inLongitude;
  late final String inPhotoUrl;
  late final String outTime;
  late final String outPhotoUrl;
  late final double outLatitude;
  late final double outLongitude;
  late final String meetingPoints;
  late final bool hasNextFolloup;
  late final String nextFollowupDate;
  late final bool hasVerified;
  late final bool isNewCustomer;
  late final String createdBy;
  late final String createdOn;
  late final String verifiedOn;
  late final String verifiedBy;
  late final String inFile;
  late final String outFile;
  late final String address;
  late final String enquiryNumber;
  late final int code;
  late final CreatedByNavigation createdByNavigation;
  late final Customer customer;
  late final String verifiedByNavigation;

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    date = json['date'] ?? "";
    dateAsString = json['dateAsString'] ?? "";
    customerId = json['customerId'] ?? "";
    contactPersonName = json['contactPersonName'] ?? "";
    contactPersonPhone = json['contactPersonPhone'] ?? "";
    inTime = json['inTime'] ?? "";
    inLatitude = double.tryParse(json['inLatitude'].toString()) ?? 0;
    inLongitude = double.tryParse(json['inLongitude'].toString()) ?? 0;
    inPhotoUrl = json['inPhotoUrl'];
    outTime = json['outTime'] ?? "";
    outPhotoUrl = json['outPhotoUrl'];
    outLatitude = json['outLatitude'].toDouble();
    outLongitude = json['outLongitude'].toDouble();
    meetingPoints = json['meetingPoints'];
    hasNextFolloup = json['hasNextFolloup'];
    nextFollowupDate = json['nextFollowupDate'];
    hasVerified = json['hasVerified'];
    isNewCustomer = json['isNewCustomer'];
    createdBy = json['createdBy'] ?? "";
    createdOn = json['createdOn'] ?? "";
    verifiedOn = json['verifiedOn'] ?? "";
    verifiedBy = json['verifiedBy'] ?? "";
    inFile = json['inFile'] ?? "";
    outFile = json['outFile'] ?? "";
    address = json['address'] ?? "";
    enquiryNumber = json['enquiryNumber'];
    code = json['code'];
    createdByNavigation =
        CreatedByNavigation.fromJson(json['createdByNavigation']);
    customer = Customer.fromJson(json['customer']);
    verifiedByNavigation = json['inPhotoUrl'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['date'] = date;
    datas['dateAsString'] = dateAsString;
    datas['customerId'] = customerId;
    datas['contactPersonName'] = contactPersonName;
    datas['contactPersonPhone'] = contactPersonPhone;
    datas['inTime'] = inTime;
    datas['inLatitude'] = inLatitude;
    datas['inLongitude'] = inLongitude;
    datas['inPhotoUrl'] = inPhotoUrl;
    datas['outTime'] = outTime;
    datas['outPhotoUrl'] = outPhotoUrl;
    datas['outLatitude'] = outLatitude;
    datas['outLongitude'] = outLongitude;
    datas['meetingPoints'] = meetingPoints;
    datas['hasNextFolloup'] = hasNextFolloup;
    datas['nextFollowupDate'] = nextFollowupDate;
    datas['hasVerified'] = hasVerified;
    datas['isNewCustomer'] = isNewCustomer;
    datas['createdBy'] = createdBy;
    datas['createdOn'] = createdOn;
    datas['verifiedOn'] = verifiedOn;
    datas['verifiedBy'] = verifiedBy;
    datas['inFile'] = inFile;
    datas['outFile'] = outFile;
    datas['address'] = address;
    datas['enquiryNumber'] = enquiryNumber;
    datas['code'] = code;
    datas['createdByNavigation'] = createdByNavigation.toJson();
    datas['customer'] = customer.toJson();
    datas['verifiedByNavigation'] = verifiedByNavigation;
    return datas;
  }
}

class CreatedByNavigation {
  CreatedByNavigation({
    required this.id,
    required this.roleId,
    required this.name,
    required this.address,
    required this.emailId,
    required this.isActive,
    required this.mobileNumber,
    required this.createdOn,
    required this.createdBy,
    required this.districts,
    required this.createdByNavigation,
    required this.idNavigation,
    required this.employeeDistricts,
    required this.employeeExpensesCreatedByNavigation,
    required this.employeeExpensesVerifiedByNavigation,
    required this.enquiriesCreatedByNavigation,
    required this.enquiriesVerifiedByNavigation,
  });
  late final String id;
  late final String roleId;
  late final String name;
  late final String address;
  late final String emailId;
  late final bool isActive;
  late final String mobileNumber;
  late final String createdOn;
  late final String createdBy;
  late final String districts;
  late final String createdByNavigation;
  late final String idNavigation;
  late final List<dynamic> employeeDistricts;
  late final List<dynamic> employeeExpensesCreatedByNavigation;
  late final List<dynamic> employeeExpensesVerifiedByNavigation;
  late final List<dynamic> enquiriesCreatedByNavigation;
  late final List<dynamic> enquiriesVerifiedByNavigation;

  CreatedByNavigation.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    roleId = json['roleId'];
    name = json['name'];
    address = json['address'] ?? "";
    emailId = json['emailId'] ?? "";
    isActive = json['isActive'];
    mobileNumber = json['mobileNumber'] ?? "";
    createdOn = json['createdOn'] ?? "";
    createdBy = json['createdBy'] ?? "";
    districts = json['districts'] ?? "";
    createdByNavigation = json['createdByNavigation'] ?? "";
    idNavigation = json['idNavigation'] ?? "";
    employeeDistricts =
        List.castFrom<dynamic, dynamic>(json['employeeDistricts']);
    employeeExpensesCreatedByNavigation = List.castFrom<dynamic, dynamic>(
        json['employeeExpensesCreatedByNavigation']);
    employeeExpensesVerifiedByNavigation = List.castFrom<dynamic, dynamic>(
        json['employeeExpensesVerifiedByNavigation']);
    enquiriesCreatedByNavigation =
        List.castFrom<dynamic, dynamic>(json['enquiriesCreatedByNavigation']);
    enquiriesVerifiedByNavigation =
        List.castFrom<dynamic, dynamic>(json['enquiriesVerifiedByNavigation']);
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['roleId'] = roleId;
    datas['name'] = name;
    datas['address'] = address;
    datas['emailId'] = emailId;
    datas['isActive'] = isActive;
    datas['mobileNumber'] = mobileNumber;
    datas['createdOn'] = createdOn;
    datas['createdBy'] = createdBy;
    datas['districts'] = districts;
    datas['createdByNavigation'] = createdByNavigation;
    datas['idNavigation'] = idNavigation;
    datas['employeeDistricts'] = employeeDistricts;
    datas['employeeExpensesCreatedByNavigation'] =
        employeeExpensesCreatedByNavigation;
    datas['employeeExpensesVerifiedByNavigation'] =
        employeeExpensesVerifiedByNavigation;
    datas['enquiriesCreatedByNavigation'] = enquiriesCreatedByNavigation;
    datas['enquiriesVerifiedByNavigation'] = enquiriesVerifiedByNavigation;
    return datas;
  }
}

class Customer {
  Customer({
    required this.id,
    required this.companyName,
    required this.address,
    required this.emailId,
    required this.officePhoneNumber,
    required this.landLineNumber,
    required this.district,
    required this.city,
    required this.createdBy,
    required this.createdOn,
    required this.updatedBy,
    required this.updatedOn,
    required this.createdByNavigation,
    required this.updatedByNavigation,
    required this.enquiries,
  });
  late final String id;
  late final String companyName;
  late final String address;
  late final String emailId;
  late final String officePhoneNumber;
  late final String landLineNumber;
  late final String district;
  late final String city;
  late final String createdBy;
  late final String createdOn;
  late final String updatedBy;
  late final String updatedOn;
  late final String createdByNavigation;
  late final String updatedByNavigation;
  late final List<dynamic> enquiries;

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['companyName'] ?? "";
    address = json['address'] ?? "";
    emailId = json['emailId'] ?? "";
    officePhoneNumber = json['officePhoneNumber'] ?? "";
    landLineNumber = json['landLineNumber'] ?? "";
    district = json['district'] ?? "";
    city = json['city'] ?? "";
    createdBy = json['createdBy'] ?? "";
    createdOn = json['createdOn'] ?? "";
    updatedBy = json['updatedBy'] ?? "";
    updatedOn = json['updatedOn'] ?? "";
    createdByNavigation = json['createdByNavigation'] ?? "";
    updatedByNavigation = json['updatedByNavigation'] ?? "";
    enquiries = List.castFrom<dynamic, dynamic>(json['enquiries']);
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['companyName'] = companyName;
    datas['address'] = address;
    datas['emailId'] = emailId;
    datas['officePhoneNumber'] = officePhoneNumber;
    datas['landLineNumber'] = landLineNumber;
    datas['district'] = district;
    datas['city'] = city;
    datas['createdBy'] = createdBy;
    datas['createdOn'] = createdOn;
    datas['updatedBy'] = updatedBy;
    datas['updatedOn'] = updatedOn;
    datas['createdByNavigation'] = createdByNavigation;
    datas['updatedByNavigation'] = updatedByNavigation;
    datas['enquiries'] = enquiries;
    return datas;
  }
}
