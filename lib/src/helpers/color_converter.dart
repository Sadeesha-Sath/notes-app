import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class ColorConverter {
  static Map<String, Map<String, Color>> _colorMap = {
    'peach': {'light': kPeachColorLight},
    'pink': {'light': kPinkColorLight},
    'orange': {'light': kOrangeColorLight},
    'red': {'light': kRedColorLight},
    'ember': {'light': kEmberColorLight},
    'brown': {'light': kBrownColorLight},
    'yellow': {'light': kYellowColorLight},
    'green': {'light': kGreenColorLight},
    'teal': {'light': kTealColorLight},
    'blue': {'light': kBlueColorLight},
    'purple': {'light': kPurpleColorLight},
    'grey': {'light': kGreyColorLight},
    'white': {'light': kWhiteColorLight},
  };
  static Map<Color?, String> _reverseMap = {};

  static Color convertColor(String colorCode) {
    var isDarkMode = Get.isDarkMode;
    if (_colorMap.containsKey(colorCode)) {
      if (!isDarkMode) {
        return _colorMap[colorCode]!['light']!;
      }
    }
    return Colors.white;
  }

  static String convertToString(Color color) {
    if (_reverseMap.isEmpty) {
      _reverseMap.addAll(_colorMap.map((key, value) => MapEntry(value['light'], key)));
      _reverseMap.addAll(_colorMap.map((key, value) => MapEntry(value['dark'], key)));
    }

    if (_reverseMap.containsKey(color)) {
      return _reverseMap[color]!;
    } else {
      return "white";
    }
  }
}
