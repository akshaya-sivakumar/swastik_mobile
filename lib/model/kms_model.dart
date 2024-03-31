class FetchkmsModel {
  FetchkmsModel({
    required this.isOk,
    required this.successMessage,
    required this.errorMessage,
    this.item,
  });
  late final bool isOk;
  late final String successMessage;
  late final String errorMessage;
  late final dynamic item;

  FetchkmsModel.fromJson(Map<String, dynamic> json) {
    isOk = json['isOk'];
    successMessage = json["successMessage"] ?? "";
    errorMessage = json["errorMessage"] ?? "";
    item = json["item"];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['isOk'] = isOk;
    datas['successMessage'] = successMessage;
    datas['errorMessage'] = errorMessage;
    datas['item'] = item;
    return datas;
  }
}
