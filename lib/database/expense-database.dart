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
    // add new expense to db
    await isar.writeTxn(() => isar.expenses.put(newExpense));

    //re-read expenses from db
    await readExpenses();
  }


  // read- expense for db
  Future<void> readExpenses() async{
    List<Expense> fetchedExpenses = await isar.expenses.where().findAll();

    // give to _allExpenses
    _allExpenses.clear();
    _allExpenses.addAll(fetchedExpenses);

    //update UI
    notifyListeners();
  }



  // update - update expense
  Future<void> updateExpense(int id, Expense updatedExpense)async {
    updatedExpense.id = id;

    //update in db
    await isar.writeTxn(() => isar.expenses.put(updatedExpense));

    // re-read expenses from db
    await readExpenses();
  }

  
  // delete - delete expense
  Future<void> deleteExpense(int id) async{
    //delete from db
    await isar.writeTxn(() => isar.expenses.delete(id));

    //re-read expenses from db
    await readExpenses();
  }
}