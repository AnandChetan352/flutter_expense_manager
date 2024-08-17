import 'package:expense_tracker/Model/data_filters.dart';
import 'package:expense_tracker/Model/expense.dart';
import 'package:expense_tracker/charts/pie_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpensesHome extends StatefulWidget {
  const ExpensesHome({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  State<StatefulWidget> createState() {
    return _ExpensesHomeState();
  }
}

//State class for home page
class _ExpensesHomeState extends State<ExpensesHome> {
  ViewDataFrom _selectedCatagory = ViewDataFrom.day;
  String _currentFilterExpenseAmt = "";
  List<Expense> _currentFilteredExpenses = [];

  @override
  void initState() {
    super.initState();
    _currentFilteredExpenses.clear();
    _currentFilteredExpenses = widget.expenses;
  }

  void _getExpense() {
    switch (_selectedCatagory) {
      case ViewDataFrom.day:
        {
          DateTime today = DateTime.now();
          DateTime startOfDay = DateTime(today.year, today.month, today.day);
          DateTime endOfDay = startOfDay
              .add(const Duration(days: 1))
              .subtract(const Duration(seconds: 1));

          var todayData = widget.expenses
              .where((expense) =>
                  expense.date.isAfter(
                      startOfDay.subtract(const Duration(seconds: 1))) &&
                  expense.date
                      .isBefore(endOfDay.add(const Duration(seconds: 1))))
              .toList();
          _currentFilterExpenseAmt = todayData
              .map((expense) => expense.amount)
              .fold(0.0, (sum, amount) => sum + amount)
              .toString();
          _currentFilteredExpenses.clear();
          _currentFilteredExpenses = todayData;
        }
      case ViewDataFrom.week:
        {
          DateTime today = DateTime.now();
          DateTime startOfWeek =
              today.subtract(Duration(days: today.weekday - 1));
          DateTime endOfDay = today
              .add(const Duration(days: 1))
              .subtract(const Duration(seconds: 1));

          var todayData = widget.expenses
              .where((expense) =>
                  expense.date.isAfter(
                      startOfWeek.subtract(const Duration(seconds: 1))) &&
                  expense.date
                      .isBefore(endOfDay.add(const Duration(seconds: 1))))
              .toList();

          _currentFilterExpenseAmt = todayData
              .map((expense) => expense.amount)
              .fold(0.0, (sum, amount) => sum + amount)
              .toString();
          _currentFilteredExpenses.clear();
          _currentFilteredExpenses = todayData;
        }

      case ViewDataFrom.month:
        {
          DateTime today = DateTime.now();
          DateTime startOfMonth = DateTime(today.year, today.month, 1);
          DateTime endOfDay = today
              .add(const Duration(days: 1))
              .subtract(const Duration(seconds: 1));

          var todayData = widget.expenses
              .where((expense) =>
                  expense.date.isAfter(
                      startOfMonth.subtract(const Duration(seconds: 1))) &&
                  expense.date
                      .isBefore(endOfDay.add(const Duration(seconds: 1))))
              .toList();
          _currentFilterExpenseAmt = todayData
              .map((expense) => expense.amount)
              .fold(0.0, (sum, amount) => sum + amount)
              .toString();
          _currentFilteredExpenses.clear();
          _currentFilteredExpenses = todayData;
        }

      case ViewDataFrom.year:
        {
          DateTime today = DateTime.now();
          DateTime startOfYear = DateTime(today.year, 1, 1);
          DateTime endOfDay = today
              .add(const Duration(days: 1))
              .subtract(const Duration(seconds: 1));

          var todayData = widget.expenses
              .where((expense) =>
                  expense.date.isAfter(
                      startOfYear.subtract(const Duration(seconds: 1))) &&
                  expense.date
                      .isBefore(endOfDay.add(const Duration(seconds: 1))))
              .toList();
          _currentFilterExpenseAmt = todayData
              .map((expense) => expense.amount)
              .fold(0.0, (sum, amount) => sum + amount)
              .toString();
          _currentFilteredExpenses.clear();
          _currentFilteredExpenses = todayData;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //top should be graph
      ExpenseChart(expenses: _currentFilteredExpenses),
      const SizedBox(height: 10),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          const Text("View:"),
                          const Spacer(),
                          DropdownButton(
                              alignment: Alignment.centerRight,
                              value: _selectedCatagory,
                              items: ViewDataFrom.values
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name.toUpperCase()),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  if (value != null) {
                                    _selectedCatagory = value;
                                    _getExpense();
                                  }
                                });
                              }),
                        ],
                      ),
                      Row(
                        children: 
                        [
                          const Text("Total:"),
                          const Spacer(),
                          Text(_currentFilterExpenseAmt)
                        ],
                      )
                    ],
                    
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16), // Space between the two cards

            Expanded(
              child: Card(
                color: Colors.blueAccent,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        const Text("View:"),
                        DropdownButton(
                            value: _selectedCatagory,
                            items: ViewDataFrom.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name.toUpperCase()),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  _selectedCatagory = value;
                                  _getExpense();
                                }
                              });
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
