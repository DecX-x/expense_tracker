
import 'package:expense_tracker/database/expense-database.dart';
import 'package:expense_tracker/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // init db
  ExpenseDatabase.initialize();

  runApp(ChangeNotifierProvider(
      create: (context) => ExpenseDatabase(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}