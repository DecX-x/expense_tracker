import 'package:expense_tracker/Models/expense.dart';
import 'package:expense_tracker/bar%20_graph/graph.dart';
import 'package:expense_tracker/components/list_tile.dart';
import 'package:expense_tracker/database/expense-database.dart';
import 'package:expense_tracker/helper/helperfn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  // text controller
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  Future<Map<int, double>>? _monthlyTotalsFuture;

  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();

    refreshGrapData();
    
    super.initState();
  }

  void refreshGrapData() {
    _monthlyTotalsFuture = Provider.of<ExpenseDatabase>(context, listen: false).calculateMonthlyTotals();
  }

  // opem expense box
  void openExpenseBox() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
              title: const Text("New Expense"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: "Name"),
                  ),


                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(hintText: "Amount"),
                  ),
                ],
              ),

              actions: [
                //cancel button
                _cancelButton(),
                //save button
                _createNewExpenseButton()

              ],
            ),
            );
        }

  //open edit box
  void openEditBox(Expense expense) {
    String existingName = expense.name;
    String existingAmount = expense.amount.toString();
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
              title: const Text("Edit Expense"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: existingName),
                  ),


                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(hintText: existingAmount),
                  ),
                ],
              ),

              actions: [
                //cancel button
                _cancelButton(),
                //save button
                _editExpenseButton(expense),

              ],
            ),
            );
  }
  
  void openDeleteBox(Expense expense) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
              title: const Text("Edit Expense"),
              actions: [
                //cancel button
                _cancelButton(),
                //save button
                _deleteExpenseButton(expense.id),

              ],
            ),
            );
  }

        @override
        Widget build(BuildContext context){
          return Consumer<ExpenseDatabase>(builder: (context, value, child) {

            int startMonth = value.getStartMonth();
            int startYear = value.getStartYear();
            int currentMonth = DateTime.now().month;
            int currentYear = DateTime.now().year;

            int monthCount = calculateMonthCount(startYear, startMonth, currentYear, currentMonth);

            return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: openExpenseBox,
              child: const Icon(Icons.add),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: FutureBuilder(
                      future: _monthlyTotalsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final monthlyTotals = snapshot.data ?? {};
                    
                          List<double> monthlySummary = List.generate(monthCount, 
                          (index) => monthlyTotals[startMonth + index] ?? 0);
                    
                          return MybarGraph(
                            monthlySummary: monthlySummary,
                            startmonth: startMonth,
                          );
                        }
                        else {
                          return const Center(child: Text("Loading.."),);
                        }
                    
                    
                      },
                      ),
                  ),
              
                Expanded(
                  child: ListView.builder(
                  itemCount: value.allExpense.length,
                  itemBuilder: (context, index) {
                    Expense individualExpense = value.allExpense[index];
                  
                    return MtListTile(
                      title: individualExpense.name,
                      trailing: formatRupiah(double.parse(individualExpense.amount.toString())),
                      onEditPressed: (context) => openEditBox(individualExpense),
                      onDeletePressed: (context) => openDeleteBox(individualExpense),
                            );
                          }
                        ),
                ),
                ],
              ),
            )
          );
        }
      );
  }

  //cancel button
  Widget _cancelButton(){
    return MaterialButton(
      onPressed: () {
        Navigator.pop(context);

        nameController.clear();
        amountController.clear();

      },
      child: const Text("Cancel"),
      );
  }


  //save button
  Widget _createNewExpenseButton(){
    return MaterialButton(
      onPressed: ()async {
        if (nameController.text.isNotEmpty &&
        amountController.text.isNotEmpty){

          //pop box
          Expense newExpense = Expense(
            name: nameController.text, 
            amount: convertStringToDouble(amountController.text),
            date: DateTime.now(),
          );

          //save to db
          await context.read<ExpenseDatabase>().createNewExpense(newExpense);

          //clear controller
          nameController.clear();
          amountController.clear();

        }

      },
      child: const Text("Save"),
    );
  }

  Widget _editExpenseButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        if (nameController.text.isNotEmpty &&
        amountController.text.isNotEmpty){
          Navigator.pop(context);

          //update expense
          Expense updatedExpense = Expense(
            name: nameController.text.isNotEmpty ? nameController.text : expense.name,
            amount: amountController.text.isNotEmpty ? convertStringToDouble(amountController.text) : expense.amount,
            date: DateTime.now(),
          );
          int existingId = expense.id;

          await context.read<ExpenseDatabase>().updateExpense(existingId, updatedExpense);
          



        }
      },
      child: const Text("Save"),
      );
      
      }

  Widget _deleteExpenseButton(int id) {
    return MaterialButton(
      onPressed: () async {
        Navigator.pop(context);

        await context.read<ExpenseDatabase>().deleteExpense(id);
      },
      child: const Text("Delete"),
      );
  }

}