import 'package:expense_tracker/expenses.dart';
import 'package:flutter/material.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: Colors.purpleAccent.shade200);
var kColorSchemeDark = ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 0, 0));

void main() {
  runApp(MaterialApp(
    darkTheme: ThemeData().copyWith(
      colorScheme: kColorSchemeDark,
      cardTheme: const CardTheme().copyWith(
        color: kColorSchemeDark.secondaryContainer,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      ),
    ),
    theme: ThemeData().copyWith(
      colorScheme: kColorScheme,
      appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer),
      cardTheme: const CardTheme().copyWith(
        color: kColorScheme.secondaryContainer,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer),
      ),
      textTheme: ThemeData().textTheme.copyWith(
            titleLarge: const TextStyle(fontSize: 20),
          ),
    ),
    home: Expenses(),
  ));
}
