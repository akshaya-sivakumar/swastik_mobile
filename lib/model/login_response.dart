class LoginResponse {
  LoginResponse({
    required this.isOk,
    required this.successMessage,
     this.errorMessage,
    required this.item,
  });
  late final bool isOk;
  late final String successMessage;
  late final Null errorMessage;
  late final Item item;
  
  LoginResponse.fromJson(Map<String, dynamic> json){
    isOk = json['isOk'];
    successMessage = json['successMessage'];
    errorMessage = null;
    item = Item.fromJson(json['item']);
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['isOk'] = isOk;
    datas['successMessage'] = successMessage;
    datas['errorMessage'] = errorMessage;
    datas['item'] = item.toJson();
    return datas;
  }
}

class Item {
  Item({
    required this.username,
    required this.password,
  });
  late final String username;
  late final String password;
  
  Item.fromJson(Map<String, dynamic> json){
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['username'] = username;
    datas['password'] = password;
    return datas;
  }
}