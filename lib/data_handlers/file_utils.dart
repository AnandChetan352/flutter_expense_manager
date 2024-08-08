import 'dart:io';
import 'package:expense_tracker/Model/expense.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class FileUtils {
  // Static method to write a list to a file
  static Future<void> writeListToFile(List<Expense> list) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/expenses.txt');

    // Convert the list to a JSON string
    String jsonString = jsonEncode(list);

    // Write the JSON string to the file
    await file.writeAsString(jsonString, mode: FileMode.write);
  }

  // Static method to read a list from a file
  static Future<List<Expense>> readListFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/expenses.txt');

      // Read the file as a string
      String jsonString = await file.readAsString();

      // Convert the JSON string back to a list of maps
      List<dynamic> jsonList = jsonDecode(jsonString);

      // Convert each map to an Expense object
      return jsonList.map((json) => Expense.fromJson(json)).toList();
    } catch (e) {
      print("Error reading file: $e");
      return [];
    }
  }
}
