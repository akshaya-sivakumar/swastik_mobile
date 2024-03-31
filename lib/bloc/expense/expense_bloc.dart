import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:swastik_mobile/model/addexpense_request.dart';
import 'package:swastik_mobile/model/expensehead_model.dart';
import 'package:swastik_mobile/repository/expense_repo.dart';

import '../../model/expenseList_model.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseInitial()) {
    on<FetchExpensehead>((event, emit) async {
      emit(ExpenseheadLoad());
      try {
        final heads = await ExpenseRepository().getHeads();

        emit(ExpenseheadDone(heads));
      } catch (e) {
        emit(ExpenseheadError(message: e.toString()));
      }
    });

    on<AddExpenseEvent>((event, emit) async {
      emit(AddExpenseLoad());
      try {
        final heads = await ExpenseRepository()
            .addExpense(event.addExpenseModel, event.file);

        emit(AddExpenseDone());
      } catch (e) {
        emit(AddExpenseError(e.toString()));
      }
    });

    on<FetchExpenses>((event, emit) async {
      emit(FetchExpensesLoad());
      try {
        final heads = await ExpenseRepository().getExpenselist();

        emit(FetchExpensesDone(heads));
      } catch (e) {
        emit(FetchExpensesError(e.toString()));
      }
    });

    on<DeleteExpenses>((event, emit) async {
      emit(DeleteExpenseLoad());
      try {
        final heads = await ExpenseRepository().deleteExpense(event.id);

        emit(DeleteExpenseDone());
      } catch (e) {
        emit(DeleteExpenseError(e.toString()));
      }
    });
  }
}
