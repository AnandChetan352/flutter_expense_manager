import 'package:expense_tracker/Model/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                expense.title,
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(children: [
                Text(
                  "\$${expense.amount.toStringAsFixed(2)}",
                ),
                const Spacer(),
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
            ]),
      ),
    );
  }
}
