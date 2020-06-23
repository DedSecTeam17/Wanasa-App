import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:vedio_calls_app/call/call_page.dart';
import 'package:vedio_calls_app/utils/AppColors.dart';
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

  @override
  void initState() {
    super.initState();
  }

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
                    Router.to(
                        context,
                        CallPage(
                          appId: "9279f5c1620f4a1f9d7f266a49d7c39d",
                          channel: widget.channelId,
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
