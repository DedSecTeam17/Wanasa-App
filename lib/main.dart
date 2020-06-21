import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vedio_calls_app/all_users_screen.dart';
import 'package:vedio_calls_app/utils/local_notificaion_helper.dart';
import 'package:vedio_calls_app/utils/router.dart';

import 'auth_screens/sign_in_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vedio Calls',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AppInit(),
    );
  }
}

class AppInit extends StatefulWidget {
  @override
  _AppInitState createState() => _AppInitState();
}

class _AppInitState extends State<AppInit> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        GlobalNotification.showNotification(message['notification']['title'],
            message['notification']['description']);
        String channelName = message['data']['channel_id'];
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        Router.toWithClear(context, AllUsersScreen());
      } else {
        Router.toWithClear(context, SignInScreen());
      }
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
