// ignore_for_file: directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/utils/constans.dart';
import 'package:music/utils/methods.dart';

class ThemeApp {
  final light = ThemeData(
    appBarTheme: const AppBarTheme(
      elevation: 0,
      foregroundColor: Colors.black,
      // backgroundColor: ConstantsApp.primaryColor,
      centerTitle: true,
      // color: ConstantsApp.primaryColor,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    useMaterial3: false,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: Colors.white,
    fontFamily: 'OpenSans',
    brightness: Brightness.light,
    textTheme: const TextTheme(),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: MaterialColorGenerator.from(ConstantsApp.primaryColor),
    ).copyWith(secondary: ConstantsApp.primaryColor).copyWith(
          background: ConstantsApp.primaryColor,
        ),
    scaffoldBackgroundColor: ConstantsApp.primaryColor,
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
      labelStyle: ConstantsApp.labelStyle,
      unselectedLabelStyle: ConstantsApp.unselectedLabelStyle,
    ),
  );
}
