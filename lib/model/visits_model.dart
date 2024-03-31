class VisitsModel {
  VisitsModel({
    required this.isOk,
    required this.successMessage,
    required this.errorMessage,
    required this.item,
  });
  late final bool isOk;
  late final String successMessage;
  late final String errorMessage;
  late final List<Item> item;

  VisitsModel.fromJson(Map<String, dynamic> json) {
    isOk = json['isOk'];
    successMessage = json['successMessage'] ?? "";
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
    required this.userId,
    required this.date,
    required this.dateAsString,
    required this.customerName,
    required this.purpose,
    required this.meetingPoints,
    required this.isCheckIn,
    required this.checkInLatitude,
    required this.checkInLongitude,
    required this.checkInTime,
    required this.checkInTimeAsString,
    required this.isCheckOut,
    required this.checkOutLatitude,
    required this.checkOutLongitude,
    required this.checkOutTime,
    required this.checkOutTimeAsString,
  });
  late final String id;
  late final String userId;
  late final String date;
  late final String dateAsString;
  late final String customerName;
  late final String purpose;
  late final String meetingPoints;
  late final bool isCheckIn;
  late final int checkInLatitude;
  late final int checkInLongitude;
  late final String checkInTime;
  late final String checkInTimeAsString;
  late final bool isCheckOut;
  late final int checkOutLatitude;
  late final int checkOutLongitude;
  late final String checkOutTime;
  late final String checkOutTimeAsString;

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    date = json['date'];
    dateAsString = json['dateAsString'];
    customerName = json['customerName'];
    purpose = json['purpose'];
    meetingPoints = json['meetingPoints'];
    isCheckIn = json['isCheckIn'];
    checkInLatitude = json['checkInLatitude'];
    checkInLongitude = json['checkInLongitude'];
    checkInTime = json['checkInTime'];
    checkInTimeAsString = json['checkInTimeAsString'];
    isCheckOut = json['isCheckOut'];
    checkOutLatitude = json['checkOutLatitude'];
    checkOutLongitude = json['checkOutLongitude'];
    checkOutTime = json['checkOutTime'] ?? "";
    checkOutTimeAsString = json['checkOutTimeAsString'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['userId'] = userId;
    datas['date'] = date;
    datas['dateAsString'] = dateAsString;
    datas['customerName'] = customerName;
    datas['purpose'] = purpose;
    datas['meetingPoints'] = meetingPoints;
    datas['isCheckIn'] = isCheckIn;
    datas['checkInLatitude'] = checkInLatitude;
    datas['checkInLongitude'] = checkInLongitude;
    datas['checkInTime'] = checkInTime;
    datas['checkInTimeAsString'] = checkInTimeAsString;
    datas['isCheckOut'] = isCheckOut;
    datas['checkOutLatitude'] = checkOutLatitude;
    datas['checkOutLongitude'] = checkOutLongitude;
    datas['checkOutTime'] = checkOutTime;
    datas['checkOutTimeAsString'] = checkOutTimeAsString;
    return datas;
  }
}
