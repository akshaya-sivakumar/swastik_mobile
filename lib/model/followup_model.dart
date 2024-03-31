class FollowupModel {
  FollowupModel({
    required this.isOk,
    required this.successMessage,
     this.errorMessage,
    required this.item,
  });
  late final bool isOk;
  late final String successMessage;
  late final Null errorMessage;
  late final List<Item> item;
  
  FollowupModel.fromJson(Map<String, dynamic> json){
    isOk = json['isOk'];
    successMessage = json['successMessage'];
    errorMessage = null;
    item = List.from(json['item']).map((e)=>Item.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['isOk'] = isOk;
    _data['successMessage'] = successMessage;
    _data['errorMessage'] = errorMessage;
    _data['item'] = item.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Item {
  Item({
    required this.customerName,
    required this.officePhone,
    required this.officeLandLineNumber,
    required this.date,
  });
  late final String customerName;
  late final String officePhone;
  late final String officeLandLineNumber;
  late final String date;
  
  Item.fromJson(Map<String, dynamic> json){
    customerName = json['customerName'];
    officePhone = json['officePhone'];
    officeLandLineNumber = json['officeLandLineNumber'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['customerName'] = customerName;
    _data['officePhone'] = officePhone;
    _data['officeLandLineNumber'] = officeLandLineNumber;
    _data['date'] = date;
    return _data;
  }
}