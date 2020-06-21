import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_box/verification_box.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:vedio_calls_app/services/auth_service.dart';
import 'package:vedio_calls_app/utils/router.dart';
import 'package:vedio_calls_app/widgets/buttons.dart';
import 'package:vedio_calls_app/widgets/custom_card.dart';

import '../all_users_screen.dart';

class SmsCodeVerification extends StatefulWidget {
  String verId;
  String phoneNumber;

  SmsCodeVerification({@required this.verId, @required this.phoneNumber});

  @override
  _SmsCodeVerificationState createState() => _SmsCodeVerificationState();
}

class _SmsCodeVerificationState extends State<SmsCodeVerification> {
  bool _verify = false;
  String _verificationCode = "";

  Future<void> _loginSMS() async {
    setState(() {
      _verify = true;
    });
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: widget.verId,
        smsCode: _verificationCode,
      );

      final FirebaseUser user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      if (user != null) {
        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

        String pushNotificationToken = await _firebaseMessaging.getToken();
        AuthService.getInstance().createUser(user, pushNotificationToken,
            (isDone, message) {
          setState(() {
            _verify = false;
          });
          if (isDone) {
            Router.toWithClear(context, AllUsersScreen());
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
          }
        });
      } else {
        setState(() {
          _verify = false;
        });
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid Sms code")));
      }
    } catch (e) {
      setState(() {
        _verify = false;
      });
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 202,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: CustomizedCard(
                screen_margin: 10,
                child: Column(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        height: 50,
                        child: VerificationBox(
                          borderRadius: 10,
                          borderWidth: 1,
                          onSubmitted: (code){
                            setState(() {
                              _verificationCode = code;
                            });
                          },
                          count: 6,
                        ),
                      ),
                    ),
//
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: VerificationCode(
//                        keyboardType: TextInputType.number,
//                        length: 4,
//                        // clearAll is NOT required, you can delete it
//                        // takes any widget, so you can implement your design
//
//                        onCompleted: (String value) {
//                          setState(() {
//                            _verificationCode = value;
//                          });
//                        },
//                        onEditing: (bool value) {},
//                      ),
//                    ),
                    AppBtnWithLoading(
                      width: MediaQuery.of(context).size.width ,
                      onTap: () async {
                        await _loginSMS();
                      },
                      child: !_verify
                          ? Text(
                              "Next",
                              style: TextStyle(color: Colors.white),
                            )
                          : Text(
                              "loading..",
                              style: TextStyle(color: Colors.white),
                            ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
