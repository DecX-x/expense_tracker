import 'package:expense_tracker/Models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier{
  static late Isar isar;

  List<Expense> _allExpenses = [];

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  List<Expense> get allExpense => _allExpenses;


  // create - add new expense
  Future<void> createNewExpense(Expense newExpense) async{
    await isar.writeTxn(() => isar.expenses.put(newExpense));
  }


  // read- expense for db
  Future<void> readExpenses() async{
    List<Expense> fetchedExpenses = await isar.expenses.where().findAll();

    _allExpenses.clear();
    _allExpenses.addAll(fetchedExpenses);

    notifyListeners();
  }



  // update - update expense
  // delete - delete expense
}