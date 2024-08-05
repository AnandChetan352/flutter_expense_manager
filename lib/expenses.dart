import 'package:expense_tracker/Model/expense.dart';
import 'package:expense_tracker/add_expense.dart';
import 'package:expense_tracker/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Expenses extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpense = [
    Expense(
        title: "Dummy Expense1",
        amount: 12,
        catagory: Catagory.food,
        date: DateTime.now()),
    Expense(
        title: "Dummy Expense2",
        amount: 120,
        catagory: Catagory.leisure,
        date: DateTime.now()),
    Expense(
        title: "Dummy Expense3",
        amount: 90,
        catagory: Catagory.work,
        date: DateTime.now()),
    Expense(
        title: "Dummy Expense4",
        amount: 102,
        catagory: Catagory.travel,
        date: DateTime.now())
  ];

  void _addExpenseModalOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => const AddExpense(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _addExpenseModalOverlay();
            },
            icon: const Icon(Icons.add),
          ),
        ],
        title: const Text("Expense Tracker"),
      ),
      body: Column(
        children: [
          const Text("data"),
          Expanded(
            child: ExpensesList(_registeredExpense),
          ),
        ],
      ),
    );
  }
}
