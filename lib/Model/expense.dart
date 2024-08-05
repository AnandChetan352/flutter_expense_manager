import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
final foramtter = DateFormat.yMd();

enum Catagory {food, travel, work, leisure}

const catagoryIcons = 
{
  Catagory.food : Icons.lunch_dining,
  Catagory.leisure : Icons.movie,
  Catagory.travel : Icons.flight_takeoff,
  Catagory.work : Icons.work
};



class Expense {
  Expense({required this.title, required this.amount, required this.date, required this.catagory})
      : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Catagory catagory;

  String get formattedDate
  {
    return foramtter.format(date);
  }
}
