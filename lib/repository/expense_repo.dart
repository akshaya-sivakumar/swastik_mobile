import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:swastik_mobile/model/addexpense_request.dart';
import 'package:swastik_mobile/model/expenseList_model.dart';
import 'package:swastik_mobile/model/expensehead_model.dart';
import 'package:swastik_mobile/resources/api_base_helper.dart';

class ExpenseRepository {
  Future<ExpenseheadModel> getHeads() async {
    var response = await ApiBaseHelper().getMethod("/Enquiry/expensehead");

    ExpenseheadModel heads =
        ExpenseheadModel.fromJson(json.decode(response.body));

    return heads;
  }

  Future<Response> addExpense(
      AddExpenseModel addExpenseModel, File photo) async {
    FileObject? file;
    file = FileObject('File', [photo.path]);
    var response = await ApiBaseHelper().postMultipartFormFile(
        "/Enquiry/expense", addExpenseModel.toJson(), file);

    return response;
  }

  Future<ExpensesListModel> getExpenselist() async {
    var response = await ApiBaseHelper().getMethod(
        "/Enquiry/expenses/00000000-0000-0000-0000-000000000000/${DateFormat("yyyy-MM-dd").format(DateTime.parse(DateTime.now().toString()))}");

    ExpensesListModel expenses =
        ExpensesListModel.fromJson(json.decode(response.body));

    return expenses;
  }

  Future<Response> deleteExpense(String id) async {
    var response = await ApiBaseHelper()
        .postMethod("/Enquiry/expense/$id/delete", jsonEncode({}));

    return response;
  }
}
