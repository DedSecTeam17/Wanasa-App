import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  GlobalKey<ScaffoldState> key;

  static void showSnackBar({String message, GlobalKey<ScaffoldState> key}) {
    key.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  static void showSnackBarWithCustomWidget({
    Widget widget,
    GlobalKey<ScaffoldState> key,
  }) {
    key.currentState.showSnackBar(SnackBar(content: widget));
  }
}
