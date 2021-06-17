import 'package:flutter/material.dart';

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: ThemeData.dark().colorScheme.copyWith(
        primary: Colors.tealAccent.shade400,
        primaryVariant: Colors.tealAccent.shade700,
      ),
);
