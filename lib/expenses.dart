import 'package:expense_tracker/Model/expense.dart';
import 'package:expense_tracker/add_expense.dart';
import 'package:expense_tracker/charts/pie_chart.dart';
import 'package:expense_tracker/data_handlers/file_utils.dart';
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
  Future<void> addExpense(Expense expense) async {
    setState(() {
      _registeredExpense.add(expense);
      
    });
    await FileUtils.writeListToFile(_registeredExpense);
  }

  Future<void> removeExpense(Expense expense) async {
    final expenseIndex = _registeredExpense.indexOf(expense);

    setState(() {
      _registeredExpense.remove(expense);
    });
    await FileUtils.writeListToFile(_registeredExpense);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(
          "Removed ${expense.title}",
        ),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () async {
            setState(() {
              _registeredExpense.insert(expenseIndex, expense);
            });
            await FileUtils.writeListToFile(_registeredExpense);
          },
        ),
      ),
    );
  }


  List<Expense> _registeredExpense = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    List<Expense> expenses = await FileUtils.readListFromFile();
    setState(() {
      _registeredExpense = expenses;
    });
  }

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
