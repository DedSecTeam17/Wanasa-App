import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vedio_calls_app/services/auth_service.dart';
import 'package:vedio_calls_app/utils/router.dart';
import 'package:vedio_calls_app/widgets/buttons.dart';
import 'package:vedio_calls_app/widgets/custom_card.dart';
import 'package:vedio_calls_app/widgets/text_filed.dart';

import '../all_users_screen.dart';
import 'code_verification_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _phoneCtrl = TextEditingController();

  bool _signIn = false;
  CountryCode c_code;
  String fullPhoneNumber = "";

  Future<void> _loginSMS() async {
    if (c_code == null || _phoneCtrl.text.isEmpty) {
      var snackBar = SnackBar(content: Text("Fill sign in info"));
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        fullPhoneNumber = c_code.dialCode + _phoneCtrl.text;
        _signIn = true;
      });
      final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
        setState(() {
          _signIn = false;
        });
      };

      final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
        setState(() {
          _signIn = false;
        });

        Router.to(
            context,
            SmsCodeVerification(
              verId: verId,
              phoneNumber: fullPhoneNumber,
            ));
      };

      final PhoneVerificationCompleted verifiedSuccess =
          (AuthCredential phoneAuthCredential) async {
//        save user data locally
        print('verified');
        setState(() {
          _signIn = false;
        });
//        sign a user and redirect him
        final FirebaseUser user = (await FirebaseAuth.instance
                .signInWithCredential(phoneAuthCredential))
            .user;
        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

        String pushNotificationToken = await _firebaseMessaging.getToken();

        AuthService.getInstance().createUser(user, pushNotificationToken,
            (isDone, message) {
          if (isDone) {
            Router.toWithClear(context, AllUsersScreen());
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
          }
        });
      };

      final PhoneVerificationFailed veriFailed = (AuthException exception) {
        setState(() {
          _signIn = false;
        });
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(exception.message)));
      };

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed,
      );
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
                      padding: const EdgeInsets.only(
                          left: 28.0, right: 28, top: 28, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: CountryCodePicker(
                              onChanged: (code) {
                                setState(() {
                                  c_code = code;
                                });
                              },
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection: 'IT',
                              favorite: ['+249', 'FR'],
                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,
                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                          ),
                          Expanded(
                            child: AppTextFiled(
                              controller: _phoneCtrl,
                              hint: 'Phone number',
                              filedValidation: (String txt) {
                                if (txt.isEmpty) {
                                  return "empty feild required ";
                                } else {
                                  return "";
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppBtnWithLoading(
                      width: MediaQuery.of(context).size.width / 1.1,
                      onTap: () async {
                        await _loginSMS();
                      },
                      child: !_signIn
                          ? Text(
                              "Sign in",
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
