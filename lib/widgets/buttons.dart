import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vedio_calls_app/utils/AppColors.dart';



class CustomButton extends StatelessWidget {
  Widget child;
  var width = 50.0;
  var height = 50.0;

  Function onTap;

  CustomButton({@required this.child, @required this.width, this.height,@required  this.onTap});

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
