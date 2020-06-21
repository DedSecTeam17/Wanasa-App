import 'package:flutter/material.dart';
import 'package:vedio_calls_app/utils/hex_color.dart';

class CustomizedCard extends StatelessWidget {
  Widget child;
  double screen_margin;

  CustomizedCard({@required this.child, this.screen_margin});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: [BoxShadow(color: HexColor("#e4e9ed"), blurRadius: 6)]),
      margin: EdgeInsets.only(
          left: screen_margin,
          right: screen_margin,
          bottom: screen_margin,
          top: screen_margin),
      child: child,
    );
  }
}
