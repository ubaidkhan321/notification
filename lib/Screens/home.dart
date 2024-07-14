import 'package:flutter/material.dart';
import 'package:task1/Screens/Notification.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  RequestNotification notification = RequestNotification();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notification.notificationpermission();
   // notification.refreshtoken();
   notification.firebaseInit(context);
    notification.getdevicetoken().then((value){
      print("Deice token");
      print(value);

    });
    notification.fetchAndShowNotifications();

  }
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Notification"),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:task1/Screens/Notification.dart';

// class Homescreen extends StatefulWidget {
//   const Homescreen({super.key});

//   @override
//   State<Homescreen> createState() => _HomescreenState();
// }

// class _HomescreenState extends State<Homescreen> {
//   RequestNotification notification = RequestNotification();
  
//   @override
//   void initState() {
//     super.initState();
//     notification.notificationpermission();
//     notification.firebaseInit(context);
//     notification.getdevicetoken().then((value) {
//       print("Device token");
//       print(value);
//     });
//     notification.fetchAndShowNotifications();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Notification"),
//         ),
//         body: Center(
//           child: Text("Home Screen"),
//         ),
//       ),
//     );
//   }
// }
