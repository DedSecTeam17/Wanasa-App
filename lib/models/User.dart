class User {
  String phoneNumber;
  String uid;
  String pushNotificationToken;

  User({this.phoneNumber, this.uid, this.pushNotificationToken});

  User.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phone_number'];
    uid = json['uid'];
    pushNotificationToken = json['push_notification_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone_number'] = this.phoneNumber;
    data['uid'] = this.uid;
    data['push_notification_token'] = this.pushNotificationToken;
    return data;
  }
}
