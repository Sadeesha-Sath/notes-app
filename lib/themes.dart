import 'package:flutter/material.dart';

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: ThemeData.dark().colorScheme.copyWith(
        primary: Colors.tealAccent.shade400,
        primaryVariant: Colors.tealAccent.shade700,
      ),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
);

final lightTheme = ThemeData.light().copyWith(
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
);
