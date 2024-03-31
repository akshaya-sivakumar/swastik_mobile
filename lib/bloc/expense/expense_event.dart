part of 'expense_bloc.dart';

class ExpenseEvent {}

class FetchExpensehead extends ExpenseEvent {
  FetchExpensehead();
}

class AddExpenseEvent extends ExpenseEvent {
  final AddExpenseModel addExpenseModel;
  final File file;
  AddExpenseEvent(this.addExpenseModel, this.file);
}

class FetchExpenses extends ExpenseEvent {
  FetchExpenses();
}

class DeleteExpenses extends ExpenseEvent {
  final String id;

  DeleteExpenses(this.id);
}
