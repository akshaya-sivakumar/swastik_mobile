import 'package:intl/intl.dart';

class ExpensesListModel {
  ExpensesListModel({
    required this.isOk,
    required this.successMessage,
    required this.errorMessage,
    required this.item,
  });
  late final bool isOk;
  late final String successMessage;
  late final String errorMessage;
  late final List<Item> item;

  ExpensesListModel.fromJson(Map<String, dynamic> json) {
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
    required this.expenseHeadId,
    required this.amount,
    required this.createdBy,
    required this.createdOn,
    required this.imageUrl,
    required this.isVerified,
    required this.verifiedOn,
    required this.verifiedBy,
    required this.file,
    required this.createdByNavigation,
    required this.expenseHead,
    required this.verifiedByNavigation,
  });
  late final String id;
  late final String expenseHeadId;
  late final int amount;
  late final String createdBy;
  late final String createdOn;
  late final String imageUrl;
  late final bool isVerified;
  late final String verifiedOn;
  late final String verifiedBy;
  late final String file;
  late final String createdByNavigation;
  late final ExpenseHead expenseHead;
  late final String verifiedByNavigation;

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expenseHeadId = json['expenseHeadId'];
    amount = json['amount'];
    createdBy = json['createdBy'] ?? "";
    createdOn = json['createdOn'] != null
        ? ((json['createdOn']?.toString().contains("T") ?? false)
            ? DateFormat("dd-MM-yyyy").format(DateTime.parse(json['createdOn']))
            : json['createdOn'])
        : "";

    imageUrl = json['imageUrl'] ?? "";
    isVerified = json['isVerified'] ?? "";
    verifiedOn = json['verifiedOn'] ?? "";
    verifiedBy = json['verifiedBy'] ?? "";
    file = json['file'] ?? "";
    createdByNavigation = json['createdByNavigation'] ?? "";
    expenseHead = ExpenseHead.fromJson(json['expenseHead']);
    verifiedByNavigation = json['verifiedByNavigation'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['id'] = id;
    datas['expenseHeadId'] = expenseHeadId;
    datas['amount'] = amount;
    datas['createdBy'] = createdBy;
    datas['createdOn'] = createdOn;
    datas['imageUrl'] = imageUrl;
    datas['isVerified'] = isVerified;
    datas['verifiedOn'] = verifiedOn;
    datas['verifiedBy'] = verifiedBy;
    datas['file'] = file;
    datas['createdByNavigation'] = createdByNavigation;
    datas['expenseHead'] = expenseHead.toJson();
    datas['verifiedByNavigation'] = verifiedByNavigation;
    return datas;
  }
}

class ExpenseHead {
  ExpenseHead({
    required this.id,
    required this.expenseHead,
    required this.employeeExpenses,
  });
  late final String id;
  late final String expenseHead;
  late final List<dynamic> employeeExpenses;

  ExpenseHead.fromJson(Map<String, dynamic> json) {
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
