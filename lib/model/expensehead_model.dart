class ExpenseheadModel {
  ExpenseheadModel({
    required this.isOk,
    required this.successMessage,
    required this.errorMessage,
    required this.item,
  });
  late final bool isOk;
  late final String successMessage;
  late final String errorMessage;
  late final List<Item> item;

  ExpenseheadModel.fromJson(Map<String, dynamic> json) {
    isOk = json['isOk'];
    successMessage = json["successMessage"] ?? "";
    errorMessage = json["errorMessage"] ?? "";
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
    required this.expenseHead,
    required this.employeeExpenses,
  });
  late final String id;
  late final String expenseHead;
  late final List<dynamic> employeeExpenses;

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expenseHead = json['expenseHead'];
    employeeExpenses =
        List.castFrom<dynamic, dynamic>(json['employeeExpenses']);
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['expenseHead'] = expenseHead;
    datas['employeeExpenses'] = employeeExpenses;
    return datas;
  }
}
