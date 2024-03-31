class CheckinstartModel {
  CheckinstartModel({
    this.id,
    this.userId,
    this.date,
    this.customerName,
    this.purpose,
    this.meetingPoints,
    this.isCheckIn,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkInTime,
    this.isCheckOut,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.checkOutTime,
  });
  String? id;
  String? userId;
  String? date;
  String? customerName;
  String? purpose;
  String? meetingPoints;
  bool? isCheckIn;
  int? checkInLatitude;
  int? checkInLongitude;
  String? checkInTime;
  bool? isCheckOut;
  int? checkOutLatitude;
  int? checkOutLongitude;
  String? checkOutTime;

  CheckinstartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    date = json['date'];
    customerName = json['customerName'];
    purpose = json['purpose'];
    meetingPoints = json['meetingPoints'];
    isCheckIn = json['isCheckIn'];
    checkInLatitude = json['checkInLatitude'];
    checkInLongitude = json['checkInLongitude'];
    checkInTime = json['checkInTime'];
    isCheckOut = json['isCheckOut'];
    checkOutLatitude = json['checkOutLatitude'];
    checkOutLongitude = json['checkOutLongitude'];
    checkOutTime = json['checkOutTime'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['userId'] = userId;
    datas['date'] = date;
    datas['customerName'] = customerName;
    datas['purpose'] = purpose;
    datas['meetingPoints'] = meetingPoints;
    datas['isCheckIn'] = isCheckIn;
    datas['checkInLatitude'] = checkInLatitude;
    datas['checkInLongitude'] = checkInLongitude;
    datas['checkInTime'] = checkInTime;
    datas['isCheckOut'] = isCheckOut;
    datas['checkOutLatitude'] = checkOutLatitude;
    datas['checkOutLongitude'] = checkOutLongitude;
    datas['checkOutTime'] = checkOutTime;
    return datas;
  }
}
