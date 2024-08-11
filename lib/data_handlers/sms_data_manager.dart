//this should be a class the returns SMS data in from of List<Expense>

//then this list needs to be appended into the JSON DB

import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';

class ReadSmsDataToExpenseList {
  final Telephony _telephonyInstance = Telephony.instance;
  final List<SmsMessage> _messages = [];
  final List<String> _transactionKeywords = ["account", "bank", "debited", "debit"];
  final List<String> _transactionCurrencyKeyword = ["INR","RS." , "RS"];

  Future<List<SmsMessage>> get messages async {
    bool permissionsGranted = await _requestSmsPermission();
    if (permissionsGranted) {
      await _readAllSms();
    }
    var filteredMessages = filterMessagesByKeywords();
    return filteredMessages;
  }

  Future<bool> _requestSmsPermission_obslete() async {
    bool? permissionsGranted =
        await _telephonyInstance.requestPhoneAndSmsPermissions;
    if (permissionsGranted != null) {
      return permissionsGranted;
    } else {
      return false;
    }
  }

  Future<bool> _requestSmsPermission() async {
    // Request permission using permission_handler
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      status = await Permission.sms.request();
    }
    return status.isGranted;
  }

  Future<void> _readAllSms() async 
  {
    
    final List<SmsMessage> messages = await _telephonyInstance.getInboxSms
    (
      columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
    );
    
    _messages.clear();
    _messages.addAll(messages);
  
  }

  List<SmsMessage> filterMessagesByKeywords() {
    return _messages.where((message) {
      for (var keyword in _transactionKeywords) {
        if (message.body?.toLowerCase().contains(keyword.toLowerCase()) ?? false) {
          return true;
        }
      }
      return false;
    }).toList();
  }
}
