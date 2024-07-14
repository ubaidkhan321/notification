
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class RequestNotification {


  FirebaseMessaging messaging = FirebaseMessaging.instance;
 
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void notificationpermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("User Granted  Permision");
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("User Granted Provisional Permision");
      }
    } else {
      if (kDebugMode) {
        print("User Deny Permision");
      }
    }
  }
  
  Future<String> getdevicetoken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void refreshtoken() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  void initlocalnotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationsetting =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var initalizationsetting = InitializationSettings(
      android: androidInitializationsetting,
    );
    await flutterLocalNotificationsPlugin.initialize(initalizationsetting,
        onDidReceiveNotificationResponse: (payload) {});
  }
  
  
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
      }
      if (kDebugMode) {
        print(message.notification!.body.toString());
      }

      initlocalnotification(context, message);
      shownotification(message);
    });
  }
    
  String generateUniqueID() {
  return DateTime.now().millisecondsSinceEpoch.toString();
}

  
  Future<void> shownotification(RemoteMessage message) async {

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      generateUniqueID(),
      "high_importance_channel",
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: "This is task des",
            ticker: "Ticker",
            priority: Priority.high,
            importance: Importance.max);
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
          0,         
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  
  void fetchAndShowNotifications() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    const notificationCollection = 'notifications';

    final QuerySnapshot querySnapshot =
        await firestore.collection(notificationCollection).get();

    for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
      final String title = doc.get('title');
      final String body = doc.get('body');

      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            Random.secure().nextInt(100000).toString(),
            "high_importance_channel",
            channelDescription: 'This is task des',
            ticker: 'Ticker',
            priority: Priority.high,
            importance: Importance.max,
          ),
        ),
      );
    }
  }

}






















// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:task1/Screens/helperclass.dart';

// class RequestNotification {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   void initConnectivityListener() {
//     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//       if (result != ConnectivityResult.none) {
//         sendPendingMessages();
//       }
//     });
//   }

//   void notificationpermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//         alert: true,
//         announcement: true,
//         badge: true,
//         carPlay: true,
//         criticalAlert: true,
//         provisional: true,
//         sound: true);
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       if (kDebugMode) {
//         print("User Granted Permission");
//       }
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       if (kDebugMode) {
//         print("User Granted Provisional Permission");
//       }
//     } else {
//       if (kDebugMode) {
//         print("User Denied Permission");
//       }
//     }
//   }

//   Future<String> getdevicetoken() async {
//     String? token = await messaging.getToken();
//     return token!;
//   }

//   void refreshtoken() {
//     messaging.onTokenRefresh.listen((event) {
//       event.toString();
//     });
//   }

//   void initlocalnotification(
//       BuildContext context, RemoteMessage message) async {
//     var androidInitializationsetting =
//         const AndroidInitializationSettings("@mipmap/ic_launcher");
//     var initalizationsetting = InitializationSettings(
//       android: androidInitializationsetting,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initalizationsetting,
//         onDidReceiveNotificationResponse: (payload) {});
//   }

//   void firebaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       if (kDebugMode) {
//         print(message.notification!.title.toString());
//       }
//       if (kDebugMode) {
//         print(message.notification!.body.toString());
//       }

//       initlocalnotification(context, message);
//       shownotification(message);
//     });
//   }

//   Future<void> shownotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       Random.secure().nextInt(100000).toString(),
//       "high_importance_channel",
//       importance: Importance.max,
//     );

//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//             channel.id.toString(), channel.name.toString(),
//             channelDescription: "This is task des",
//             ticker: "Ticker",
//             priority: Priority.high,
//             importance: Importance.max);
//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);

//     Future.delayed(Duration.zero, () {
//       flutterLocalNotificationsPlugin.show(
//           0,
//           message.notification!.title.toString(),
//           message.notification!.body.toString(),
//           notificationDetails);
//     });
//   }

//   void fetchAndShowNotifications() async {
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;
//     const notificationCollection = 'notifications';

//     final QuerySnapshot querySnapshot =
//         await firestore.collection(notificationCollection).get();

//     for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
//       final String title = doc.get('title');
//       final String body = doc.get('body');

//       await flutterLocalNotificationsPlugin.show(
//         0,
//         title,
//         body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             Random.secure().nextInt(100000).toString(),
//             "high_importance_channel",
//             channelDescription: 'This is task des',
//             ticker: 'Ticker',
//             priority: Priority.high,
//             importance: Importance.max,
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> sendPendingMessages() async {
//     final List<Map<String, dynamic>> pendingMessages = await SharedPrefsHelper.getPendingMessages();
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;
//     const notificationCollection = 'notifications';

//     for (final message in pendingMessages) {
//       await firestore.collection(notificationCollection).add({
//         'title': message['title'],
//         'body': message['body'],
//         'received_at': Timestamp.now(),
//       });
//     }

//     await SharedPrefsHelper.clearPendingMessages();
//   }
// }















































































// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class RequestNotification {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   void notificationpermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//         alert: true,
//         announcement: true,
//         badge: true,
//         carPlay: true,
//         criticalAlert: true,
//         provisional: true,
//         sound: true);
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       if (kDebugMode) {
//         print("User Granted Permission");
//       }
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       if (kDebugMode) {
//         print("User Granted Provisional Permission");
//       }
//     } else {
//       if (kDebugMode) {
//         print("User Denied Permission");
//       }
//     }
//   }

//   Future<String> getdevicetoken() async {
//     String? token = await messaging.getToken();
//     return token!;
//   }

//   void refreshtoken() {
//     messaging.onTokenRefresh.listen((event) {
//       event.toString();
//     });
//   }

//   void initlocalnotification(
//       BuildContext context, RemoteMessage message) async {
//     var androidInitializationsetting =
//         const AndroidInitializationSettings("@mipmap/ic_launcher");
//     var initializationsetting = InitializationSettings(
//       android: androidInitializationsetting,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationsetting,
//         onDidReceiveNotificationResponse: (payload) {});
//   }

//   void firebaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       if (kDebugMode) {
//         print("Message received: ${message.notification!.title}");
//       }
//       initlocalnotification(context, message);
//       shownotification(message);
//     });
//   }

//   Future<void> shownotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = const  AndroidNotificationChannel(
//       'high_importance_channel', // Channel ID
//       "High Importance Notifications", // Channel name
//       importance: Importance.max,
//     );

//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       channel.id,
//       channel.name,
//       channelDescription: "This channel is used for important notifications.",
//       ticker: "Ticker",
//       priority: Priority.high,
//       importance: Importance.max,
//     );

//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);

//     // Generate a unique notification ID
//     int notificationId = Random().nextInt(100000);

//     flutterLocalNotificationsPlugin.show(
//       notificationId,
//       message.notification!.title,
//       message.notification!.body,
//       notificationDetails,
//     );
//   }

//   void fetchAndShowNotifications() async {
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;
//     const notificationCollection = 'notifications';

//     final QuerySnapshot querySnapshot =
//         await firestore.collection(notificationCollection).get();

//     for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
//       final String title = doc.get('title');
//       final String body = doc.get('body');
     
//       await flutterLocalNotificationsPlugin.show(
//         Random().nextInt(100000), // Use a unique ID for each notification
//         title,
//         body,
//     const    NotificationDetails(
//           android: AndroidNotificationDetails(
//             'high_importance_channel', // Channel ID
//             "High Importance Notifications", // Channel name
//             channelDescription: 'This channel is used for important notifications.',
//             ticker: 'Ticker',
//             priority: Priority.high,
//             importance: Importance.max,
//           ),
//         ),
//       );
//     }
//   }
// }


// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class RequestNotification {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   void notificationpermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       if (kDebugMode) {
//         print("User Granted Permission");
//       }
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       if (kDebugMode) {
//         print("User Granted Provisional Permission");
//       }
//     } else {
//       if (kDebugMode) {
//         print("User Denied Permission");
//       }
//     }
//   }

//   Future<String> getdevicetoken() async {
//     String? token = await messaging.getToken();
//     return token!;
//   }

//   void refreshtoken() {
//     messaging.onTokenRefresh.listen((event) {
//       event.toString();
//     });
//   }

//   void initlocalnotification(BuildContext context, RemoteMessage message) async {
//     var androidInitializationsetting =
//         const AndroidInitializationSettings("@mipmap/ic_launcher");
//     var initializationsetting = InitializationSettings(
//       android: androidInitializationsetting,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationsetting,
//         onDidReceiveNotificationResponse: (payload) {});
//   }

//   void firebaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       if (kDebugMode) {
//         print("Message received: ${message.notification!.title}");
//       }
//       initlocalnotification(context, message);
//       shownotification(message);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       if (kDebugMode) {
//         print("Message clicked!");
//       }
//       // Handle the message when the app is opened from a terminated state
//     });

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }

//   Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     if (kDebugMode) {
//       print("Handling a background message: ${message.messageId}");
//     }
//     shownotification(message);
//   }

//   Future<void> shownotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = const AndroidNotificationChannel(
//       'high_importance_channel', // Channel ID
//       "High Importance Notifications", // Channel name
//       importance: Importance.max,
//     );

//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       channel.id,
//       channel.name,
//       channelDescription: "This channel is used for important notifications.",
//       ticker: "Ticker",
//       priority: Priority.high,
//       importance: Importance.max,
//     );

//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);

//     // Generate a unique notification ID
//     int notificationId = Random().nextInt(100000);

//     flutterLocalNotificationsPlugin.show(
//       notificationId,
//       message.notification!.title,
//       message.notification!.body,
//       notificationDetails,
//     );
//   }

//   void fetchAndShowNotifications() async {
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;
//     const notificationCollection = 'notifications';

//     final QuerySnapshot querySnapshot =
//         await firestore.collection(notificationCollection).get();

//     for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
//       final String title = doc.get('title');
//       final String body = doc.get('body');

//       await flutterLocalNotificationsPlugin.show(
//         Random().nextInt(100000), // Use a unique ID for each notification
//         title,
//         body,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'high_importance_channel', // Channel ID
//             "High Importance Notifications", // Channel name
//             channelDescription: 'This channel is used for important notifications.',
//             ticker: 'Ticker',
//             priority: Priority.high,
//             importance: Importance.max,
//           ),
//         ),
//       );
//     }
//   }
// }


// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class RequestNotification {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   void notificationpermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       if (kDebugMode) {
//         print("User Granted Permission");
//       }
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       if (kDebugMode) {
//         print("User Granted Provisional Permission");
//       }
//     } else {
//       if (kDebugMode) {
//         print("User Denied Permission");
//       }
//     }
//   }

//   Future<String> getdevicetoken() async {
//     String? token = await messaging.getToken();
//     return token!;
//   }

//   void refreshtoken() {
//     messaging.onTokenRefresh.listen((event) {
//       event.toString();
//     });
//   }

//   void initlocalnotification(BuildContext context, RemoteMessage message) async {
//     var androidInitializationsetting =
//         const AndroidInitializationSettings("@mipmap/ic_launcher");
//     var initializationsetting = InitializationSettings(
//       android: androidInitializationsetting,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationsetting,
//         onDidReceiveNotificationResponse: (payload) {});
//   }

//   void firebaseInit(BuildContext context,) async {
//     FirebaseMessaging.onMessage.listen((message) {
//       if (kDebugMode) {
//         print("Message received: ${message.notification!.title}");
//       }

   
//       initlocalnotification(context, message);
//       shownotification(message);
     
//     });


 

//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       if (kDebugMode) {
//         print("Message clicked!");
//       }
//       // Handle the message when the app is opened from a terminated state
//     });

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }

   
//   Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     if (kDebugMode) {
//       print("Handling a background message: ${message.messageId}");
//     }

//     // Store the message in Firestore for later retrieval
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;
//     const notificationCollection = 'notifications';
//      DocumentReference store = firestore.collection(notificationCollection).doc();

//     await store.set({
//       'id': store.id,
//       'title': message.notification!.title,
//       'body': message.notification!.body,
//       'received_at': Timestamp.now(),
//     });

//     shownotification(message);
//   }

//   Future<void> shownotification(RemoteMessage message) async {

//     AndroidNotificationChannel channel =  AndroidNotificationChannel(
     
//       Random.secure().nextInt(100000).toString(),  // Channel ID
//       "High Importance Notifications", // Channel name
//       importance: Importance.max,
//     );

//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       channel.id.toString(),
//       channel.name,
//       channelDescription: "This channel is used for important notifications.",
//       ticker: "Ticker",
//       priority: Priority.high,
//       importance: Importance.max,
//     );

//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);

//     // Generate a unique notification ID
//     int notificationId = Random().nextInt(100000);

//     flutterLocalNotificationsPlugin.show(
//       notificationId,
//       message.notification!.title,
//       message.notification!.body,
//       notificationDetails,
//     );
//   }



// void fetchAndShowNotifications() async {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   const notificationCollection = 'notifications';
//   final QuerySnapshot querySnapshot = await firestore.collection(notificationCollection).get();

//   for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
//     final String title = doc.get('title');
//     final String body = doc.get('body');
//     //final String notificationId = doc.get('id'); // Use the document ID as the notification ID

//     await flutterLocalNotificationsPlugin.show(
//       //int.parse(notificationId),
//        // Convert the notification ID to an integer
//       Random().nextInt(100000),
//       title,
//       body,
//        NotificationDetails(
//         android: AndroidNotificationDetails(
       
//           Random().nextInt(100000).toString(),
//           'High Importance Notifications',
//           channelDescription: 'This channel is used for important notifications.',
//           ticker: 'Ticker',
//           priority: Priority.high,
//           importance: Importance.max,
//         ),
//       ),
//     );
//   }
// }



//delete nahi karna.............................................................................................................

  // void fetchAndShowNotifications() async {
  //   final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   const notificationCollection = 'notifications';

  //   final QuerySnapshot querySnapshot =
  //       await firestore.collection(notificationCollection).get();

  //   for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
  //     final String title = doc.get('title');
  //     final String body = doc.get('body');

  //     await flutterLocalNotificationsPlugin.show(
  //       Random().nextInt(100000), // Use a unique ID for each notification
  //       title,
  //       body,
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'high_importance_channel', // Channel ID
  //           "High Importance Notifications", // Channel name
  //           channelDescription: 'This channel is used for important notifications.',
  //           ticker: 'Ticker',
  //           priority: Priority.high,
  //           importance: Importance.max,
  //         ),
  //       ),
  //     );
  //   }
  // }
//}

