import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vedio_calls_app/models/User.dart';

class AuthService {
  static AuthService _singleton = AuthService._internal();

  factory AuthService() {
    return _singleton;
  }

  static AuthService getInstance() {
    if (_singleton == null) {
      _singleton = AuthService._internal();
      return _singleton;
    }
    return _singleton;
  }

  AuthService._internal();

/*
* check if user exist
* if not exist create new user
* else return true
* @user  get it from sign in using phone number
* */
  void createUser(FirebaseUser user, String token, Function response) async {
    await Firestore.instance
        .collection("users")
        .where("uid", isEqualTo: user.uid)
        .getDocuments()
        .then((QuerySnapshot snapShot) async {
      if (snapShot != null) {
        if (snapShot.documents != null) {
          if (snapShot.documents.isNotEmpty) {
//              we already has user data time to save to locally
            response(true, "we alredy had user data base");
          } else {
            bool userCreated = await firestoreCreateUser(user, token);
            if (userCreated) {
//           save to local here
              response(true, "user created successfully");
            }
          }
        } else {
          bool userCreated = await firestoreCreateUser(user, token);
          if (userCreated) {
//           save to local here
            response(true, "user created successfully");
          }
        }
      } else {
        bool userCreated = await firestoreCreateUser(user, token);
        if (userCreated) {
//           save to local here
          response(true, "user created successfully");
        }
      }
    }).catchError((err) {
      response(true, err.toString());

//user not found we need to return data
    });
  }

  Future<bool> firestoreCreateUser(FirebaseUser user, String token) async {
    DocumentReference documentRefrence = await Firestore.instance
        .collection("users")
        .add(User(
                phoneNumber: user.phoneNumber,
                uid: user.uid,
                pushNotificationToken: token)
            .toJson());

    return documentRefrence != null;
  }

  Future<List<User>> getAllUsers() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection("users").getDocuments();
    return snapshot.documents.map((doc) => User.fromJson(doc.data)).toList();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
