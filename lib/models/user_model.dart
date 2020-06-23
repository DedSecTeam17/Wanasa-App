import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vedio_calls_app/services/auth_service.dart';
import 'package:vedio_calls_app/services/push_notification.dart';
import 'package:vedio_calls_app/utils/enums.dart';

import 'User.dart';

class UserModel with ChangeNotifier {
//  data
  List<User> _users = List<User>();
  FirebaseUser currentUser;
  String cCode = "+249";
  String _verificationCode = "";

//  state
  bool _isSignIn = false;
  bool _isVerifying = false;
  bool _isLoadUsers = false;
  bool _isPushingNotification = false;

  //  getters

  bool get isPushingNotification => _isPushingNotification;

  bool get isLoadUsers => _isLoadUsers;
  bool _loadingCurrentUser = true;

  bool get loadingCurrentUser => _loadingCurrentUser;

  bool get isSignIn => _isSignIn;

  bool get isVerifying => _isVerifying;

  List<User> get users => _users;

  void setCountryCode(String code) {
    cCode = code;
    notifyListeners();
  }

  /*
  * @code country code 
  * @phone full phone number 
  * */
  Future<void> doSignIn(String phone, Function onExecuted) async {
    if (cCode.isNotEmpty == null || phone.isEmpty) {
      onExecuted(false, "code and phone required",
          SignInStatus.SUCCESS_SMS_SENT, 0, null);
    } else {
      String fullPhone = cCode + phone;
      _isSignIn = true;
      notifyListeners();

      final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
        _isSignIn = false;
        notifyListeners();
      };

      final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
        _isSignIn = false;
        notifyListeners();

        onExecuted(true, "sms code sent", SignInStatus.SUCCESS_SMS_SENT, verId,
            fullPhone);
      };

      final PhoneVerificationCompleted verifiedSuccess =
          (AuthCredential phoneAuthCredential) async {
        final FirebaseUser user = (await FirebaseAuth.instance
                .signInWithCredential(phoneAuthCredential))
            .user;
        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

        String pushNotificationToken = await _firebaseMessaging.getToken();

        AuthService.getInstance().createUser(user, pushNotificationToken,
            (isDone, message) {
          _isSignIn = false;
          notifyListeners();
          if (isDone) {
            onExecuted(true, "user created succesfully",
                SignInStatus.SUCCESS_NEW_ACCOUNT, 0, null);
          } else {
            onExecuted(
                false, "error while create user", SignInStatus.FAIL, 0, null);
          }
        });
      };

      final PhoneVerificationFailed veriFailed = (AuthException exception) {
        _isSignIn = false;
        notifyListeners();

        onExecuted(false, "verification failed", SignInStatus.FAIL, 0, null);
      };

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullPhone,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed,
      );
    }
  }

  /*
  * @verificationCode code sent by google we need to set it 
  * */
  void setVerificationCode(String verificationCode) {
    this._verificationCode = verificationCode;
    notifyListeners();
  }

/*
* @verId each sign in operation has verification id related with sms code 
* */
  Future<void> doVerification(String verId, Function onExecuted) async {
    _isVerifying = true;
    notifyListeners();
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verId,
        smsCode: this._verificationCode,
      );

      final FirebaseUser user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      if (user != null) {
        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

        String pushNotificationToken = await _firebaseMessaging.getToken();
        AuthService.getInstance().createUser(user, pushNotificationToken,
            (isDone, message) {
          _isVerifying = false;
          notifyListeners();
          if (isDone) {
            onExecuted(true, message, VerificationStatus.SUCCESS_NEW_ACCOUNT);
          } else {
            onExecuted(false, message, VerificationStatus.FAIL);
          }
        });
      } else {
        _isVerifying = false;
        notifyListeners();
        onExecuted(false, "Invalid credential", VerificationStatus.FAIL);
      }
    } catch (e) {
      _isVerifying = false;
      notifyListeners();
      onExecuted(false, e.toString(), VerificationStatus.FAIL);
    }
  }

/*
* get current user who sign in , session handled by firebase auth lib
* */
  getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    _loadingCurrentUser = false;
    notifyListeners();
  }

  getAllUsers() {}

/*
* @channelName shared channel between sender and receiver to communicate 
* @user intended user that we need to push notification for him/here  
* */
  pushNotification(String channelName, User user, Function onExecuted) {
    PushNotificationService.getInstance().push(
        user: user,
        channelName: channelName,
        title: "${currentUser.phoneNumber} call you",
        description: currentUser.phoneNumber,
        action: (sent, message) {
          if (sent) {
            onExecuted(true, message);
          } else {
            onExecuted(false, message);
          }
        });
  }
}
