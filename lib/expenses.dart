import 'package:expense_tracker/Model/expense.dart';
import 'package:expense_tracker/add_expense.dart';
import 'package:expense_tracker/charts/pie_chart.dart';
import 'package:expense_tracker/data_handlers/file_utils.dart';
import 'package:expense_tracker/data_handlers/sms_data_manager.dart';
import 'package:expense_tracker/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Expenses extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> 
{
  ///method to add expense
  Future<void> addExpense(Expense expense) async {
    setState(() {
      //update UI with Set State
      _registeredExpense.add(expense);
    });

    //Update local JSON DB
    await FileUtils.writeListToFile(_registeredExpense);
  }

  ///method to remove expense item
  Future<void> removeExpense(Expense expense) async {

    //index of itme to remove
    final expenseIndex = _registeredExpense.indexOf(expense);

    setState(() {
      //update UI
      _registeredExpense.remove(expense);
    });
    //Update Local JSON DB
    await FileUtils.writeListToFile(_registeredExpense);

    //Clear Previously Displayed Snack Bar
    ScaffoldMessenger.of(context).clearSnackBars();
    //Display new Snack Bar
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
    //load expenses from JSON DB
    _loadExpenses();
  }

  ///Load expenses from JSON DB
  Future<void> _loadExpenses() async 
  {
    //read the local JSON DB
    List<Expense> expenses = await FileUtils.readListFromFile();
    setState(()
    {
      //update UI
      _registeredExpense = expenses;
    });
  }

  ///display add expenses overlay 
  void _addExpenseModalOverlay()
  {
    //display modal sheet to add the overlay to "add Expense"
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => AddExpense(
        onAddExpense: addExpense,
      ),
    );
  }

  void _readSmsData()
  {
    ReadSmsDataToExpenseList smsListReader = ReadSmsDataToExpenseList();
    var allSms = smsListReader.messages;
  }

  @override
  Widget build(BuildContext context) 
  {
    //if no expense is added
    Widget mainContent =
        const Center(child: Text("No Expenses Found! Start Adding Some."));

    //update UI if expenses are added/loaded
    if (_registeredExpense.isNotEmpty) 
    {
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
          IconButton(
            onPressed: () {
              _readSmsData();
            },
            icon: const Icon(Icons.sms),
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
