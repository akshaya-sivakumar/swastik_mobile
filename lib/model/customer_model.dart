class CustomerModel {
  CustomerModel({
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

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['companyName'];
    address = json['address'];
    emailId = json['emailId'];
    officePhoneNumber = json['officePhoneNumber'];
    landLineNumber = json['landLineNumber'];
    district = json['district'];
    city = json['city'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'] ?? "";
    updatedBy = json['updatedBy'] ?? "";
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
