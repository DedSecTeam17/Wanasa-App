import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vedio_calls_app/call/incoming_call_screen.dart';
import 'package:vedio_calls_app/utils/local_notificaion_helper.dart';
import 'package:vedio_calls_app/utils/router.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  BuildContext context;

  void setUpFirebase(BuildContext context) {
    this.context = context;
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions();

    firebaseCloudMessagingListeners();
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        String channelName = message['data']['channel_id'];

        GlobalNotification.showNotification(
            message['notification']['title'], message['notification']['body']);

        Router.to(
            context,
            IncomingCallScreen(
                phoneNumber: message['notification']['title'],
                channelId: channelName));
      },
      onResume: (Map<String, dynamic> message) async {
        print(message);
        String channelName = message['data']['channel_id'];

        Router.to(
            context,
            IncomingCallScreen(
                phoneNumber: message['data']['title'],
                channelId: channelName));
      },
      onLaunch: (Map<String, dynamic> message) async {
        String channelName = message['data']['channel_id'];

        print(message);

        Router.to(
            context,
            IncomingCallScreen(
                phoneNumber: message['data']['title'],
                channelId: channelName));
      },
    );
  }

  show(message) {
    String channelName = message['data']['channel_id'];

    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => IncomingCallScreen(
            phoneNumber: message['notification']['title'],
            channelId: channelName)));
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
//      print("Settings registered: $settings");
    });
  }


}
