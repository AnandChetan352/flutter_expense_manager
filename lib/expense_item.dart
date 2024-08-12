import 'package:expense_tracker/Model/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    //card 
    return Card(
      //add padding
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        //1st child is a column to structure verticle elements
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //title of expense
              Text(
                expense.title,
                textAlign: TextAlign.left,
              ),
              //spacing
              const SizedBox(
                height: 10,
              ),
              //row to add detailed expense elements
              Row(children: [
                //ammount
                Text(
                  "\$${expense.amount.toStringAsFixed(2)}",
                ),
                //space evenly
                const Spacer(),
                //row for icon and date
                Row(
                  children: [
                    Icon(catagoryIcons[expense.catagory]),
                    const SizedBox(width: 10),
                    Text(
                      expense.formattedDate,
                    ),
                  ],
                ),
              ]),
              ///todo : edit expense icon button to add here
            ]),
      ),
    );
  }
}
