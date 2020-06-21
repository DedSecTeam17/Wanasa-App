import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:vedio_calls_app/models/User.dart';

class PushNotificationService {
  //service_not_available

  static final PushNotificationService _singleton =
      new PushNotificationService.getInstance();

  factory PushNotificationService() {
    return _singleton;
  }

  String err_message = "الخدمه غير متوفره حاليا!!";

  PushNotificationService.getInstance();

  Future<void> push(
      {@required User user,
      @required String channelName,
      @required String title,
      @required String description,
      @required Function action}) async {
    try {
      final response = await http.post(
          "https://firebase-pusher.herokuapp.com/api/notification/push",
          body: {
            "title": title,
            "description": description,
            "channel_name": channelName,
            "push_token": user.pushNotificationToken
          });
      Map<String, dynamic> result = json.decode(response.body);
      action(true, result["message"]);
    } catch (e) {
      action(false, e.toString());
    }
  }
}
