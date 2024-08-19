import 'package:expense_tracker/Model/data_filters.dart';
import 'package:expense_tracker/Model/expense.dart';
import 'package:expense_tracker/charts/pie_chart.dart';
import 'package:expense_tracker/data_handlers/file_utils.dart';
import 'package:expense_tracker/data_handlers/sms_data_manager.dart';
import 'package:expense_tracker/expenses_list.dart';
import 'package:flutter/material.dart';

class ExpensesHome extends StatefulWidget {
  const ExpensesHome(
      {super.key, required this.onRemoveExpense});

  final void Function(Expense expense) onRemoveExpense;

  @override
  State<StatefulWidget> createState() {
    return _ExpensesHomeState();
  }
}

// State class for home page
class _ExpensesHomeState extends State<ExpensesHome> {
  ViewDataFrom _selectedCategory = ViewDataFrom.day;
  String _currentFilterExpenseAmt = "0.0";
  List<Expense> _allFilteredExpenses = [];
  List<Expense> _currentFilteredExpenses = [];
  Catagory _selectedCatagory = Catagory.food;
  String minPaidTax = "";
  String maxPaidTax = "";

  Future<void> _readSmsData() async {
    ReadSmsDataToExpenseList smsListReader = ReadSmsDataToExpenseList();
    var smsData = await smsListReader.convertSmsToExpense();
    setState(() {
      _allFilteredExpenses = smsData;
    });
    await FileUtils.writeListToFile(_allFilteredExpenses);
  }

  @override
  void initState() {
    super.initState();
    _updateExpenses();
    _getTaxForExpenses();
  }

  void _updateExpenses() {
    DateTime today = DateTime.now();
    DateTime startOfPeriod;
    DateTime endOfDay =
        today.add(const Duration(days: 1)).subtract(const Duration(seconds: 1));

    switch (_selectedCategory) {
      case ViewDataFrom.day:
        startOfPeriod = DateTime(today.year, today.month, today.day);
        break;
      case ViewDataFrom.week:
        startOfPeriod = today.subtract(Duration(days: today.weekday - 1));
        break;
      case ViewDataFrom.month:
        startOfPeriod = DateTime(today.year, today.month, 1);
        break;
      case ViewDataFrom.year:
        startOfPeriod = DateTime(today.year, 1, 1);
        break;
    }

    var filteredData = _currentFilteredExpenses
        .where((expense) =>
            expense.date
                .isAfter(startOfPeriod.subtract(const Duration(seconds: 1))) &&
            expense.date.isBefore(endOfDay.add(const Duration(seconds: 1))))
        .toList();

    setState(() {
      _currentFilterExpenseAmt = filteredData
          .map((expense) => expense.amount)
          .fold(0.0, (sum, amount) => sum + amount)
          .toStringAsFixed(2);
      _currentFilteredExpenses = filteredData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Top should be graph
      ExpenseChart(expenses: _currentFilteredExpenses),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Prevents dialog from being dismissed
                    builder: (BuildContext ctx) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                  await _readSmsData();

                  // Hide the processing dialog
                  Navigator.of(context).pop(); // Close the dialog
                  setState(() {
                    _updateExpenses();
                  });
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: Colors.green.shade500),
                child: const Text(
                  "Refresh SMS Data",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 5),
      IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 5,
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Expenses",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            "For:",
                            style: TextStyle(color: Colors.white),
                          ),
                          const Spacer(),
                          DropdownButton<ViewDataFrom>(
                            dropdownColor: Colors.blueAccent,
                            value: _selectedCategory,
                            items: ViewDataFrom.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.name.toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedCategory = value;
                                   _updateExpenses();
                                  _getTaxForExpenses();
                                });
                              }
                            },
                            underline: Container(),
                            iconEnabledColor: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            "Spent:",
                            style: TextStyle(color: Colors.white),
                          ),
                          const Spacer(),
                          Text(
                            _currentFilterExpenseAmt,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 5,
                color: Colors.redAccent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Taxes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      DropdownButton<Catagory>(
                        dropdownColor: Colors.red,
                        value: _selectedCatagory,
                        items: Catagory.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.name.toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCatagory = value;
                            _getTaxForExpenses();
                          });
                        },
                        underline: Container(),
                        iconEnabledColor: Colors.white,
                        alignment: Alignment.centerLeft,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Min Tax: $minPaidTax",
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Max Tax: $maxPaidTax",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Expanded(
        child: ExpensesList(_currentFilteredExpenses,
            onRemoveExpense: widget.onRemoveExpense),
      )
    ]);
  }

  void _getTaxForExpenses() {
    // Logic for calculating taxes based on the filtered expenses
    var expense =
        ExpenseBucket.forCatagory(_currentFilteredExpenses, _selectedCatagory);
    setState(() {
      minPaidTax =
          _calculateMinTax(expense.totalExpense, _selectedCatagory).toString();
      maxPaidTax =
          _calculateMaxTax(expense.totalExpense, _selectedCatagory).toString();
    });
  }

  // Constants for tax rates
  final double minFoodTaxRate = 0.05; // 5%
  final double maxFoodTaxRate = 0.10; // 10%
  final double minTravelTaxRate = 0.08; // 8%
  final double maxTravelTaxRate = 0.15; // 15%
  final double minLeisureTaxRate = 0.12; // 12%
  final double maxLeisureTaxRate = 0.18; // 18%
  final double minWorkTaxRate = 0.10; // 10%
  final double maxWorkTaxRate = 0.20; // 20%

  double _calculateMinTax(double amount, Catagory category) {
    double tax;

    switch (category) {
      case Catagory.food:
        tax = amount * minFoodTaxRate;
        break;
      case Catagory.travel:
        tax = amount * minTravelTaxRate;
        break;
      case Catagory.leisure:
        tax = amount * minLeisureTaxRate;
        break;
      case Catagory.work:
        tax = amount * minWorkTaxRate;
        break;
      default:
        throw ArgumentError('Invalid category');
    }

    return double.parse(tax.toStringAsFixed(2));
  }

  double _calculateMaxTax(double amount, Catagory category) {
    double tax;

    switch (category) {
      case Catagory.food:
        tax = amount * maxFoodTaxRate;
        break;
      case Catagory.travel:
        tax = amount * maxTravelTaxRate;
        break;
      case Catagory.leisure:
        tax = amount * maxLeisureTaxRate;
        break;
      case Catagory.work:
        tax = amount * maxWorkTaxRate;
        break;
      default:
        throw ArgumentError('Invalid category');
    }

    return double.parse(tax.toStringAsFixed(2));
  }
}
