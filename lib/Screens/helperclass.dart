// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPrefsHelper {
//   static const String _keyPendingMessages = 'pending_messages';

//   static Future<void> saveMessage(String title, String body) async {
//     final prefs = await SharedPreferences.getInstance();
//     final List<String> pendingMessages =
//         prefs.getStringList(_keyPendingMessages) ?? [];

//     pendingMessages.add(jsonEncode({
//       'id': DateTime.now().millisecondsSinceEpoch.toString(),  // Unique ID
//       'title': title,
//       'body': body,
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//     }));

//     await prefs.setStringList(_keyPendingMessages, pendingMessages);
//   }

//   static Future<List<Map<String, dynamic>>> getPendingMessages() async {
//     final prefs = await SharedPreferences.getInstance();
//     final List<String> pendingMessages =
//         prefs.getStringList(_keyPendingMessages) ?? [];

//     return pendingMessages
//         .map((message) => Map<String, dynamic>.from(jsonDecode(message)))
//         .toList();
//   }

//   static Future<void> clearPendingMessages() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_keyPendingMessages);
//   }
// }
