import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vedio_calls_app/models/User.dart';
import 'package:vedio_calls_app/services/auth_service.dart';
import 'package:vedio_calls_app/services/push_notification.dart';
import 'package:vedio_calls_app/utils/AppColors.dart';
import 'package:vedio_calls_app/utils/random_name.dart';
import 'package:vedio_calls_app/widgets/custom_card.dart';

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
                          setState(() {
                            _selectedPhone = user.phoneNumber;
                          });
                          PushNotificationService.getInstance().push(
                              user: user,
                              channelName: myPhoneNumber +
                                  "_" +
                                  user.phoneNumber +
                                  "_" +
                                  new DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                              title: "$myPhoneNumber call you",
                              description: myPhoneNumber,
                              action: (sent, message) {
                                setState(() {
                                  _selectedPhone = "";
                                  _calling = false;
                                });
                                if (sent) {
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
