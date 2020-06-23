import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vedio_calls_app/models/User.dart';
import 'package:vedio_calls_app/services/auth_service.dart';
import 'package:vedio_calls_app/services/push_notification.dart';
import 'package:vedio_calls_app/utils/AppColors.dart';
import 'package:vedio_calls_app/utils/firebase_notification_handler.dart';
import 'package:vedio_calls_app/utils/random_name.dart';
import 'package:vedio_calls_app/utils/router.dart';
import 'package:vedio_calls_app/widgets/custom_card.dart';

import 'call/call_page.dart';
import 'call/incoming_call_screen.dart';
import 'main.dart';

class AllUsersScreen extends StatefulWidget {
  @override
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  List<User> _users = List<User>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _loadUsers = true;
  String myPhoneNumber = "";
  String _selectedPhone = "";

  bool _calling = false;
  var _key = GlobalKey<ScaffoldState>();

//
  bool _validateError = false;
  bool _video = true;
  bool _audio = true;
  bool _screen = false;
  String _profile = "720p";
  final String _appId = "fbb98c8ddc4a406caaba86d87125c412";

  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _frameRateController = TextEditingController();

  String _codec = "h264";
  String _mode = "live";

  _loadAllUsers() async {
    myPhoneNumber = (await FirebaseAuth.instance.currentUser()).phoneNumber;
    _users = await AuthService.getInstance().getAllUsers();
    setState(() {
      _refreshController.refreshCompleted();
      _loadUsers = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new FirebaseNotifications().setUpFirebase(context);

    _loadAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Text(
            "Wanassa",
            style: TextStyle(color: AppColors.mainColor),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: Image.asset(
                "assets/images/logo.png",
                width: 35,
                height: 35,
              ),
            )
          ],
        ),
        body: !_loadUsers
            ? SmartRefresher(
                controller: _refreshController,
                onRefresh: () {
                  _loadAllUsers();
                },
                child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: _users.length,
                    itemBuilder: (ctx, index) {
                      return _userItem(_users.elementAt(index));
                    }),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget _userItem(User user) {
    return user.phoneNumber != myPhoneNumber
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(),
              child: CustomizedCard(
                screen_margin: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage("https://i.pravatar.cc/300"),
                        ),
                      ],
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          GenerateName.getName().replaceAll("_", " "),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            user.phoneNumber,
                            style: TextStyle(
                                color: Colors.orangeAccent, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                        icon: !_calling && _selectedPhone != user.phoneNumber
                            ? Icon(
                                Icons.video_call,
                                color: Colors.green,
                              )
                            : CircularProgressIndicator(),
                        onPressed: () {
                          String channelName = myPhoneNumber +
                              "_" +
                              user.phoneNumber +
                              "_" +
                              new DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                          setState(() {
                            _selectedPhone = user.phoneNumber;
                          });
                          PushNotificationService.getInstance().push(
                              user: user,
                              channelName: channelName,
                              title: "$myPhoneNumber call you",
                              description: myPhoneNumber,
                              action: (sent, message) {
                                setState(() {
                                  _selectedPhone = "";
                                  _calling = false;
                                });
                                if (sent) {
                                  Router.to(
                                      context,
                                      CallPage(
                                        appId:
                                            "9279f5c1620f4a1f9d7f266a49d7c39d",
                                        channel: channelName,
                                        video: _video,
                                        audio: _audio,
                                        screen: _screen,
                                        profile: _profile,
                                        width: _widthController.text,
                                        height: _heightController.text,
                                        framerate: _frameRateController.text,
                                        codec: _codec,
                                        mode: _mode,
                                      ));
//                                  Scaffold.of(context).showSnackBar(
//                                      SnackBar(content: Text(message) ,key: _key,));
                                } else {
//                                  Scaffold.of(context).showSnackBar(
//                                      SnackBar(content: Text(message) ,key: _key,));
                                }
                              });

//        start vedio call with him
                        }),
                  ),
                ),
              ),
            ),
          )
        : SizedBox();
  }
}
