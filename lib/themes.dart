import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: kDarkBackground,
  fontFamily: GoogleFonts.lato().fontFamily,
  colorScheme: ThemeData.dark().colorScheme.copyWith(
        primary: Colors.tealAccent.shade400,
        primaryVariant: Colors.tealAccent.shade700,
      ),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(kElevatedBackgroundDark),
    foregroundColor: MaterialStateProperty.all(kElevatedForegroundDark),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
  )),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: GoogleFonts.lato().fontFamily,
  scaffoldBackgroundColor: kLightBackground,
  // colorScheme: ColorScheme.light(),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
  )),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
);
