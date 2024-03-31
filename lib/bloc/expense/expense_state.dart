part of 'expense_bloc.dart';

class ExpenseState {}

final class ExpenseInitial extends ExpenseState {}

class ExpenseheadLoad extends ExpenseState {}

class ExpenseheadDone extends ExpenseState {
  final ExpenseheadModel heads;

  ExpenseheadDone(this.heads);
}

class ExpenseheadError extends ExpenseState {
  final String message;

  ExpenseheadError({required this.message});
}

class AddExpenseLoad extends ExpenseState {}

class AddExpenseDone extends ExpenseState {}

class AddExpenseError extends ExpenseState {
  final String message;
  AddExpenseError(this.message);
}

class FetchExpensesLoad extends ExpenseState {}

class FetchExpensesDone extends ExpenseState {
  final ExpensesListModel expenses;

  FetchExpensesDone(this.expenses);
}

class DeleteExpenseLoad extends ExpenseState {}

class DeleteExpenseDone extends ExpenseState {}

class DeleteExpenseError extends ExpenseState {
  final String message;

  DeleteExpenseError(this.message);
}

class FetchExpensesError extends ExpenseState {
  final String message;

  FetchExpensesError(this.message);
}
