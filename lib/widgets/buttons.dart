import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vedio_calls_app/utils/AppColors.dart';

//
class AppBtn extends StatelessWidget {
  var text = "";
  var width = 45.0;
  var height = 56.0;
  Function onTap;

  AppBtn({@required this.text, @required this.width, this.height, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      margin: EdgeInsets.all(25.0),
      height: height==null ? 35 : height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
//                    border: Border.all(color: Colors.greenAccent,width: 1.0)
      ),
      child: FlatButton(
        color: AppColors.accent,
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}

class AppBtnWithLoading extends StatelessWidget {
  Widget child;
  var width = 50.0;
  var height = 50.0;

  Function onTap;

  AppBtnWithLoading({@required this.child, @required this.width, this.height,@required  this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.all(25.0),
        height: 50,
        width: width == null ? MediaQuery.of(context).size.width : width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: FlatButton(
          color: AppColors.mainColor,
          onPressed: onTap,
          child: child,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ));
  }
}
