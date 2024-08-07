import 'package:expense_tracker/Model/expense.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ExpenseChart extends StatelessWidget
{
  const ExpenseChart({super.key, required this.expenses});
  
  final List<Expense> expenses;


  //create a expense data map




  double _getExpenseForCatagory(Catagory catagory)
  {
    final expenseBucket = ExpenseBucket.forCatagory(expenses, catagory);
    return expenseBucket.totalExpense;
  }

  @override
  Widget build(BuildContext context) 
  {

      Map<String, double> dataMap = {
    "Travel": _getExpenseForCatagory(Catagory.travel),
    "Food": _getExpenseForCatagory(Catagory.food),
    "Leisure": _getExpenseForCatagory(Catagory.leisure),
    "Work": _getExpenseForCatagory(Catagory.work),
  };
   
   return Padding(
     padding: const EdgeInsets.all(20.0),
     child: Center(
       child: PieChart(
          dataMap: dataMap,
          animationDuration: const Duration(milliseconds: 5000),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 3.2,
        
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: 32,
          centerText: "Expenses",
          legendOptions: const LegendOptions(
            showLegendsInRow: true,
            legendPosition: LegendPosition.bottom,
            showLegends: true,
            legendShape: BoxShape.circle,
            
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: true,
            decimalPlaces: 2,
          ),
          // gradientList: ---To add gradient colors---
          // emptyColorGradient: ---Empty Color gradient---
        ),
     ),
   ) ;
  }

}