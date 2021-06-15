import 'package:flutter/material.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: kLightBackground,
    iconTheme: IconThemeData().copyWith(color: kLightBackground),
    accentColor: Colors.grey.shade600,
    bottomAppBarColor: kBottomBarColorLight,
    backgroundColor: kLightBackground,
    canvasColor: kLightBackground,
    primaryColor: Colors.black,
    toggleableActiveColor: Colors.blueGrey,
    floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
      backgroundColor: kFABColorLight,
      foregroundColor: Colors.white,
    ));
