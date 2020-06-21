import 'package:flutter/material.dart';

class AppTextFiled extends StatelessWidget {
  TextEditingController controller;
  String hint;
  TextInputType textInputType;
  int maxLength;
  double btnPadding;
  Function filedValidation;
  bool isPassword;
  IconData iconData;

  AppTextFiled(
      {@required this.controller,
      @required this.hint,
      this.textInputType,
      this.maxLength,
      this.isPassword = false,
      this.btnPadding,
      this.iconData,
      @required this.filedValidation});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(btnPadding == null ? 0.0 : btnPadding),
      child: TextFormField(
        validator: filedValidation,
        controller: controller,
        keyboardType: textInputType,
        obscureText: isPassword,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(5),
//            labelStyle: TextStyle(color: AppColors.mainColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: Icon(this.iconData),
            hintText: hint),
      ),
    );
  }
}
