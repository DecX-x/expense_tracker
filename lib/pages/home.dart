import 'package:expense_tracker/Models/expense.dart';
import 'package:expense_tracker/database/expense-database.dart';
import 'package:expense_tracker/helper/helperfn.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
    
    super.initState();
  }

  // opem expense box
  void openExpenseBox() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("New Expense"),
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

  @override
  Widget build(BuildContext context){
    return Consumer<ExpenseDatabase>(builder: (context, value, child) => Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openExpenseBox,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: value.allExpense.length,
        itemBuilder: (context, index) {
          Expense individualExpense = value.allExpense[index];


          return ListTile(
            title: Text(individualExpense.name),
            trailing: Text(formatRupiah(double.parse(individualExpense.amount.toString()))),
          );
        }
        ),
    ));
  
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



}