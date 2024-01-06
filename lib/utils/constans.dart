// ignore_for_file: lines_longer_than_80_chars, constant_identifier_names, prefer_single_quotes

import 'package:flutter/material.dart';

class ConstantsApp {
  //colors
  static const primaryColor = Color.fromARGB(255, 34, 125, 209);
  static const buttonColorPrimary = Color.fromRGBO(20, 135, 173, 0.4);
  static const buttonColorSecondary = Color.fromRGBO(141, 26, 26, 0.4);
  static const buttonColorTertiary = Color.fromRGBO(67, 201, 85, 0.4);

  static const purplePrimaryColor = Color(0xffB12579);
  static const purpleSecondaryColor = Color(0xff542B6A);
  static const purpleTerctiaryColor = Color(0xff692A6D);
  static const blueTertiaryColor = Color(0xff056DA1);
  static const blueBorderColor = Color(0xffB2C8DE);

  //text
  static const labelStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 40);
  static const unselectedLabelStyle = TextStyle(color: Color.fromARGB(96, 95, 92, 92), fontWeight: FontWeight.w600, fontSize: 24);
}

enum AppStatusCode {
  NOINTERNET,
  VALIDATION,
  SERVER,
  NOUSER,
}
