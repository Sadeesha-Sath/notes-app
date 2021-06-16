import 'package:flutter/material.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

final lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: kLightBackground,
  appBarTheme: ThemeData.light().appBarTheme.copyWith(
        backgroundColor: kLightBackground,
        foregroundColor: Colors.black,
      ),
  iconTheme: ThemeData.light().iconTheme.copyWith(color: kLightBackground),
  accentColor: Colors.blue,
  bottomAppBarColor: kBottomBarColorLight,
  backgroundColor: kLightBackground,
  canvasColor: kLightBackground,
  primaryColor: Colors.black,
  toggleableActiveColor: Colors.teal.shade600,
  floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
    backgroundColor: kFABColorLight,
    foregroundColor: Colors.white,
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: kDarkBackground,
  appBarTheme: ThemeData.dark().appBarTheme.copyWith(
        backgroundColor: kDarkBackground,
        foregroundColor: kLightBackground,
      ),
  iconTheme: ThemeData.dark().iconTheme.copyWith(color: kLightBackground),
  accentColor: Colors.blue.shade400,
  bottomAppBarColor: kBottomBarColorDark,
  backgroundColor: kDarkBackground,
  canvasColor: kDarkBackground,
  primaryColor: Color(0xFFDFDFDF),
  toggleableActiveColor: Colors.teal.shade400,
  floatingActionButtonTheme: ThemeData.dark().floatingActionButtonTheme.copyWith(
        backgroundColor: kFABColorLight,
        foregroundColor: Colors.white,
      ),
);
