import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:vedio_calls_app/call/call_page.dart';
import 'package:vedio_calls_app/utils/AppColors.dart';
import 'package:vedio_calls_app/utils/agora_config.dart';
import 'package:vedio_calls_app/utils/router.dart';
import 'package:vedio_calls_app/widgets/buttons.dart';

//IncomingCallScreen
class IncomingCallScreen extends StatefulWidget {
  String channelId;
  String phoneNumber;

  IncomingCallScreen({@required this.phoneNumber, @required this.channelId});

  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 150,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.mainColor),
                    image: DecorationImage(
                        image: NetworkImage("https://i.pravatar.cc/300"),
                        fit: BoxFit.contain),
                    borderRadius: BorderRadius.circular(150)),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.phoneNumber,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 18),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Incoming Call",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              )
            ],
          ),
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  onPressed: () {
                    Router.toWithReplacement(
                        context,
                        CallPage(
                          appId: AgoraConfig.appId,
                          channel: widget.channelId,
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
                  },
                  child: Icon(
                    Icons.call,
                    color: Colors.greenAccent,
                    size: 50,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.call_end,
                    color: Colors.redAccent,
                    size: 50,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
