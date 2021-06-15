import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class ColorConverter {
  static Map<String, Map<String, Color>> _colorMap = {
    'peach': {'light': kPeachColorLight, 'dark': kPeachColorDark},
    'pink': {'light': kPinkColorLight, 'dark': kPinkColorDark},
    'orange': {'light': kOrangeColorLight, 'dark': kOrangeColorDark},
    'red': {'light': kRedColorLight, 'dark': kRedColorDark},
    'ember': {'light': kEmberColorLight, 'dark': kEmberColorDark},
    'brown': {'light': kBrownColorLight, 'dark': kBrownColorDark},
    'yellow': {'light': kYellowColorLight, 'dark': kYellowColorDark},
    'green': {'light': kGreenColorLight, 'dark': kGreenColorDark},
    'teal': {'light': kTealColorLight, 'dark': kTealColorDark},
    'blue': {'light': kBlueColorLight, 'dark': kBlueColorDark},
    'purple': {'light': kPurpleColorLight, 'dark': kPurpleColorDark},
    'grey': {'light': kGreyColorLight, 'dark': kGreyColorDark},
    'primary': {'light': kWhiteColorLight, 'dark': kBlackColorDark},
  };
  static Map<Color?, String> _reverseMap = {};

  static Color convertColor(String colorCode) {
    var isDarkMode = Get.isDarkMode;
    if (_colorMap.containsKey(colorCode)) {
      if (!isDarkMode) {
        return _colorMap[colorCode]!['light']!;
      } else {
        return _colorMap[colorCode]!['dark']!;
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
      return "primary";
    }
  }
}
