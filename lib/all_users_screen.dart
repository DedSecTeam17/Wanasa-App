import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vedio_calls_app/models/User.dart';
import 'package:vedio_calls_app/models/user_model.dart';
import 'package:vedio_calls_app/services/auth_service.dart';
import 'package:vedio_calls_app/services/push_notification.dart';
import 'package:vedio_calls_app/utils/AppColors.dart';
import 'package:vedio_calls_app/utils/agora_config.dart';
import 'package:vedio_calls_app/utils/firebase_notification_handler.dart';
import 'package:vedio_calls_app/utils/random_name.dart';
import 'package:vedio_calls_app/utils/router.dart';
import 'package:vedio_calls_app/widgets/custom_card.dart';
import 'package:provider/provider.dart';
import 'package:vedio_calls_app/widgets/snack_bar.dart';
import 'call/call_page.dart';
import 'call/incoming_call_screen.dart';
import 'main.dart';

class AllUsersScreen extends StatefulWidget {
  @override
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  var _key = GlobalKey<ScaffoldState>();

//

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new FirebaseNotifications().setUpFirebase(context);
    Future.microtask(() => context.read<UserModel>().getCurrentUser());
    Future.microtask(() => context.read<UserModel>().getAllUsers());
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
        body: !context.watch<UserModel>().isLoadUsers
            ? LoadingOverlay(
                child: SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () {
                    context.read<UserModel>().getAllUsers();
                  },
                  child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: context.watch<UserModel>().users.length,
                      itemBuilder: (ctx, index) {
                        return _userItem(
                            context.read<UserModel>().users.elementAt(index));
                      }),
                ),
                isLoading: context.watch<UserModel>().isPushingNotification,
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget _userItem(User user) {
    String currentUserPhoneNumber =
        context.read<UserModel>().currentUser.phoneNumber;
    return user.phoneNumber != currentUserPhoneNumber
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
                        icon: Icon(
                          Icons.video_call,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          pushNotification(user, currentUserPhoneNumber);
                        }),
                  ),
                ),
              ),
            ),
          )
        : SizedBox();
  }

  //pushNotification
  pushNotification(User user, String currentUserPhoneNumber) {
    String channelName = currentUserPhoneNumber +
        "_" +
        user.phoneNumber +
        "_" +
        new DateTime.now().millisecondsSinceEpoch.toString();

    context.read<UserModel>().setSelectedPhone(user.phoneNumber);

    context.read<UserModel>().pushNotification(channelName, user,
        (sent, message) {
      if (sent) {
        Router.to(
            context,
            CallPage(
              appId: AgoraConfig.appId,
              channel: channelName,
              video: AgoraConfig.video,
              audio: AgoraConfig.audio,
              screen: AgoraConfig.screen,
              profile: AgoraConfig.profile,
              width: AgoraConfig.widthController.text,
              height: AgoraConfig.heightController.text,
              framerate: AgoraConfig.frameRateController.text,
              codec: AgoraConfig.codec,
              mode: AgoraConfig.mode,
            ));
      } else {
        AppSnackBar.showSnackBar(message: message, key: _key);
      }
    });
  }
}
