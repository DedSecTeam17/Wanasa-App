import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_box/verification_box.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:vedio_calls_app/models/user_model.dart';
import 'package:vedio_calls_app/services/auth_service.dart';
import 'package:vedio_calls_app/utils/enums.dart';
import 'package:vedio_calls_app/utils/router.dart';
import 'package:vedio_calls_app/widgets/buttons.dart';
import 'package:vedio_calls_app/widgets/custom_card.dart';
import 'package:vedio_calls_app/widgets/snack_bar.dart';

import '../all_users_screen.dart';

import 'package:provider/provider.dart';

class SmsCodeVerification extends StatelessWidget {
  String verId;
  String phoneNumber;

  SmsCodeVerification({@required this.verId, @required this.phoneNumber});

  var _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
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
                          onSubmitted: (code) {
                            context.read<UserModel>().setVerificationCode(code);
                          },
                          count: 6,
                        ),
                      ),
                    ),
                    CustomButton(
                      width: MediaQuery.of(context).size.width,
                      onTap: () async {
                        await verify(context);
                      },
                      child: !context.watch<UserModel>().isVerifying
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

  Future<void> verify(BuildContext context) async {
    await context.read<UserModel>().doVerification(verId,
        (executed, message, VerificationStatus status) {
      switch (status) {
        case VerificationStatus.FAIL:
          AppSnackBar.showSnackBar(message: message, key: _key);
          break;
        case VerificationStatus.SUCCESS_NEW_ACCOUNT:
          Router.toWithClear(context, AllUsersScreen());
      }
    });
  }
}
