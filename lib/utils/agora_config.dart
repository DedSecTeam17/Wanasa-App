import 'package:flutter/material.dart';

//global configuration for agora cp
class AgoraConfig {
  static final String appId = "9279f5c1620f4a1f9d7f266a49d7c39d";

  static bool validateError = false;
  static bool video = true;
  static bool audio = true;
  static bool screen = false;
  static String profile = "720p";

  static final widthController = TextEditingController();
  static final heightController = TextEditingController();
  static final frameRateController = TextEditingController();

  static String codec = "h264";
  static String mode = "live";
}
