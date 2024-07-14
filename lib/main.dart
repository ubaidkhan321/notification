import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task1/Screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print(message.notification!.title.toString());
  }
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  const notificationCollection = 'notifications';
  // Store notification data in Cloud Firestore
  await firestore.collection(notificationCollection).add({
    'title': message.notification!.title,
    'body': message.notification!.body,
    'received_at': Timestamp.now(),
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Homescreen());
  }
}







// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

// import 'package:task1/Screens/home.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   FirebaseFirestore.instance.settings = const Settings(
//   persistenceEnabled: true,
// );

//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//   runApp(const MyApp());
// }

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();

//   if (kDebugMode) {
//     print("Background message received: ${message.notification!.title}");
//      final FirebaseFirestore firestore = FirebaseFirestore.instance;
//     const notificationCollection = 'notifications';
//      DocumentReference store = firestore.collection(notificationCollection).doc();

   
//   try {
//     await store.set({
//       'id': store.id,
//       'title': message.notification!.title,
//       'body': message.notification!.body,
//       'received_at': Timestamp.now(),
//     });
//   } catch (e) {
//     // Network error, save locally
   
   
//   }
// }
  
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const Homescreen(),
//     );
//   }
// }
