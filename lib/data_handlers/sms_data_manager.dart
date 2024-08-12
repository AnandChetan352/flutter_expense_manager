import 'dart:isolate';
import 'package:expense_tracker/Model/expense.dart';
import 'package:expense_tracker/data_handlers/filterKeywords.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'dart:async';

class ReadSmsDataToExpenseList {
  final Telephony _telephonyInstance = Telephony.instance;
  final List<SmsMessage> _messages = [];
  final List<Expense> expenses = []; 
  final List<String> _transactionKeywords = [
    "account",
    "bank",
    "debited",
    "debit"
  ];

  Future<List<Expense>> convertSmsToExpense()
  async {
    for(var message in await messages)
    {
      //create expense object from Message 
      Expense expense = Expense(title: message.address ?? "SMS_EXPENSE_DATA", 
      amount: _getAmountFromMessageBody(message.body ), date: convertEpochToDateTime(message.date), catagory: _getExpenseCatagory(message.body));
      expenses.add(expense);
    }
    var a = 1;
    return expenses;
  }

  static double _getAmountFromMessageBody(String? body)
  {

  if (body == null) return 0.0;

  // Define a regex pattern for currency amounts (e.g., 1000, 1000.00, 1,000)
  final regex = RegExp(r'\b\d{1,3}(?:,\d{3})*(?:\.\d{2})?\b');
  final match = regex.firstMatch(body);

  if (match != null) {
    // Convert the matched amount to a double
    final amountStr = match.group(0)?.replaceAll(',', '');
    return double.tryParse(amountStr ?? "0.0") ?? 0.0;
  }

  return 0.0;
}

  static DateTime convertEpochToDateTime(int? epochMilliseconds) 
  {
    if(epochMilliseconds == null)
    {
      return DateTime.now();
    }
    return DateTime.fromMillisecondsSinceEpoch(epochMilliseconds);
  }

    static Catagory _getExpenseCatagory(String? messageBody)
    {
      if(messageBody != null)
      {

    final Map<Catagory, List<String>> categoryKeywords = {
      Catagory.food: FilterKeywords.foodKeywords,
      Catagory.travel: FilterKeywords.travelKeywords,
      Catagory.work: FilterKeywords.workKeywords,
      Catagory.leisure: FilterKeywords.leisureKeywords,
    };

    for (var entry in categoryKeywords.entries) {
      if (entry.value.any((keyword) => messageBody.toLowerCase().contains(keyword.toLowerCase()))) {
        return entry.key;
      }
    }
      }
      return Catagory.leisure;
  
  }



  static const int chunkSize = 10000;

  Future<List<SmsMessage>> get messages async {
    bool permissionsGranted = await _requestSmsPermission();
    if (permissionsGranted) {
      await _readAllSms();
    }
    var filteredMessages = await filterMessagesByKeywordsParallel();
    _messages.clear();
    return filteredMessages;
  }

  ///Request SMS Permission
  Future<bool> _requestSmsPermission() async {
    // Request permission using permission_handler
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      status = await Permission.sms.request();
    }
    return status.isGranted;
  }

  Future<void> _readAllSms() async {
    List<SmsMessage> messages = await _telephonyInstance.getInboxSms(
      columns: [SmsColumn.SUBJECT , SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
    );

    _messages.clear();
    _messages.addAll(messages);
  }

  Future<List<SmsMessage>> filterMessagesByKeywordsParallel() async {
    // Create a receive port for the isolate to communicate
    final receivePort = ReceivePort();

    // Spawn an isolate
    await Isolate.spawn(_filterMessagesIsolate, receivePort.sendPort);

    // Send the messages and keywords to the isolate
    final sendPort = await receivePort.first as SendPort;
    final responsePort = ReceivePort();

    // Split messages into chunks
    final chunks = _messages
        .asMap()
        .entries
        .where((entry) => entry.key % chunkSize == 0)
        .map((entry) => _messages.sublist(
            entry.key,
            (entry.key + chunkSize) < _messages.length
                ? (entry.key + chunkSize)
                : _messages.length))
        .toList();

    sendPort.send([chunks, _transactionKeywords, responsePort.sendPort]);

    // Wait for the filtered list of messages
    var filteredMessages = await responsePort.first as List<SmsMessage>;

    return filteredMessages;
  }

  void _filterMessagesIsolate(SendPort initialSendPort) {
    final port = ReceivePort();
    initialSendPort.send(port.sendPort);

    port.listen((message) {
      final List<List<SmsMessage>> messageChunks = message[0];
      final List<String> keywords = message[1];
      final SendPort replyPort = message[2];

      final filteredMessages = <SmsMessage>[];

      // Process each chunk
      for (var chunk in messageChunks) {
        final chunkFiltered = chunk.where((message) {
          for (var keyword in keywords) {
            var messageBody = message.body?.toLowerCase();
            if (messageBody != null) {
              if (messageBody.contains(keyword.toLowerCase()) && (messageBody.contains("debit") || messageBody.contains("debited"))) 
              {
                return true;
              }
            }
          }
          return false;
        }).toList();

        filteredMessages.addAll(chunkFiltered);
      }

      replyPort.send(filteredMessages);
    });
  }
}
