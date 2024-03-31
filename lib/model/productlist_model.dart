class ProductlistModel {
  ProductlistModel({
    required this.isOk,
    required this.successMessage,
    required this.errorMessage,
    required this.item,
  });
  late final bool isOk;
  late final String successMessage;
  late final String errorMessage;
  late final List<Item> item;

  ProductlistModel.fromJson(Map<String, dynamic> json) {
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
    required this.productName,
    required this.enquiryProducts,
  });
  late final String id;
  late final String productName;
  late final List<dynamic> enquiryProducts;

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    enquiryProducts = List.castFrom<dynamic, dynamic>(json['enquiryProducts']);
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['productName'] = productName;
    datas['enquiryProducts'] = enquiryProducts;
    return datas;
  }
}
