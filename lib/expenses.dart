import 'package:expense_tracker/Model/expense.dart';
import 'package:expense_tracker/add_expense.dart';
import 'package:expense_tracker/charts/pie_chart.dart';
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
  void addExpense(Expense expense) {
    setState(() {
      _registeredExpense.add(expense);
    });
  }

  void removeExpense(Expense expense) {
    
    final expenseIndex = _registeredExpense.indexOf(expense);

    setState(() {
      _registeredExpense.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text("Removed ${expense.title}",),
        action: SnackBarAction
        (
          label: "Undo",
          onPressed: ()
          {
            setState(() {
              _registeredExpense.insert(expenseIndex, expense);
            });
            
          },
        ),
      ),
    );
  }

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
      isScrollControlled: true,
      context: context,
      builder: (ctx) => AddExpense(
        onAddExpense: addExpense,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent =
        const Center(child: Text("No Expenses Found! Start Adding Some."));

    if (_registeredExpense.isNotEmpty) {
      mainContent = ExpensesList(
        _registeredExpense,
        onRemoveExpense: removeExpense,
      );
    }
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
          ExpenseChart(expenses: _registeredExpense),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
