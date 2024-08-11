import 'package:expense_tracker/Model/expense.dart';
import 'package:expense_tracker/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget 
{
  //default constructor with positional and named arguments
  const ExpensesList(this.expenses, {super.key, required this.onRemoveExpense});

  //list of my DTO Expense
  final List<Expense> expenses;

  //StateLifting -> method to be passed by caller
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context)
  {
    //build expense using the expenses list
    return ListView.builder(
      //count or length 
      itemCount: expenses.length,

      itemBuilder: (ctx, index) => 
      //dismissible -> swipe to delete items
      Dismissible(
        //identifier in list
        key: ValueKey(expenses[index]),
        background: Container
        (
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        //widget to be displayed
        child: ExpenseItem(expenses[index]),
      ),
    );
  }
}
