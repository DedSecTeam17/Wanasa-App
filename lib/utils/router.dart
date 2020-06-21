import 'package:flutter/material.dart';

class Router {
  static void to(context, newScreen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext ctx) {
      return newScreen;
    }));
  }

  static void toWithReplacement(BuildContext context,  newScreen) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext ctx) {
      return newScreen;
    }));
  }

  static void toWithClear(context, newScreen) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext ctx) => newScreen),
        (Route<dynamic> route) => false);
  }


  static void toWithClearParentPage(context,name) {
    Navigator.popUntil(context,    ModalRoute.withName('/${name}'));
  }




  static void back(context) {
    Navigator.of(context).pop();
  }

  static void toAndOpenAsDialog(context, newScreen){
    Navigator.of(context).push(
      MaterialPageRoute(
          fullscreenDialog: true,
          builder: (BuildContext ctx) {
            return newScreen;
          }),
    );
  }
}
