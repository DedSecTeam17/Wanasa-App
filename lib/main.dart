import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedio_calls_app/all_users_screen.dart';
import 'package:vedio_calls_app/call/incoming_call_screen.dart';
import 'package:vedio_calls_app/models/user_model.dart';
import 'package:vedio_calls_app/utils/firebase_notification_handler.dart';
import 'package:vedio_calls_app/utils/local_notificaion_helper.dart';
import 'package:vedio_calls_app/utils/router.dart';

import 'auth_screens/sign_in_screen.dart';

//top level function
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  print("Background : ---->      " + message.toString());
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => UserModel())],
    child: MyApp(),
  ));
}

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new FirebaseNotifications().setUpFirebase(navigatorKey.currentContext);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        Router.toWithReplacement(context, AllUsersScreen());
      } else {
        Router.toWithReplacement(context, SignInScreen());
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

  void showNotificationDialog(String notificationMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            content: Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Icon(
                      Icons.notifications,
                      color: Theme.of(context).primaryColor,
                      size: 66,
                    ),
                  ),
                  Text(
                    notificationMessage ?? "",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
            contentPadding:
                EdgeInsets.only(top: 32, bottom: 8, left: 16, right: 16),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(16.0)));
      },
    ).then((value) => {});
  }
}
