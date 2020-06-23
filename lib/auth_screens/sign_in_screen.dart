import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vedio_calls_app/models/user_model.dart';
import 'package:vedio_calls_app/services/auth_service.dart';
import 'package:vedio_calls_app/utils/enums.dart';
import 'package:vedio_calls_app/utils/router.dart';
import 'package:vedio_calls_app/widgets/buttons.dart';
import 'package:vedio_calls_app/widgets/custom_card.dart';
import 'package:vedio_calls_app/widgets/snack_bar.dart';
import 'package:vedio_calls_app/widgets/text_filed.dart';
import 'package:provider/provider.dart';
import '../all_users_screen.dart';
import 'code_verification_screen.dart';

class SignInScreen extends StatelessWidget {
  TextEditingController _phoneCtrl = TextEditingController();

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
                      padding: const EdgeInsets.only(
                          left: 28.0, right: 28, top: 28, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: CountryCodePicker(
                              onChanged: (code) {
                                context
                                    .read<UserModel>()
                                    .setCountryCode(code.dialCode);
                              },
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection: '+249',
                              favorite: [
                                '+249',
                              ],
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
                    CustomButton(
                      width: MediaQuery.of(context).size.width / 1.1,
                      onTap: () async {
                        await signIn(context);
                      },
                      child: !context.watch<UserModel>().isSignIn
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

  Future<void> signIn(BuildContext context) async {
    await context.read<UserModel>().doSignIn(_phoneCtrl.text.trim(),
        (bool executed, String message, SignInStatus status, String verId,
            String fullPhone) {
      print(message);
      switch (status) {
        case SignInStatus.FAIL:
          AppSnackBar.showSnackBar(message: message, key: _key);
          break;
        case SignInStatus.SUCCESS_NEW_ACCOUNT:
          Router.toWithClear(context, AllUsersScreen());
          break;
        case SignInStatus.SUCCESS_SMS_SENT:
          Router.to(
              context,
              SmsCodeVerification(
                verId: verId,
                phoneNumber: fullPhone,
              ));
          break;
        case SignInStatus.SUCCESS_ALREADY_HAVE_ACCOUNT:
          break;
      }
    });
  }
}
