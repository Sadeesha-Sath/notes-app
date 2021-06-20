import 'package:flutter/material.dart';
import 'package:get/get.dart';

const InputDecoration textFieldDecorationLight = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 22.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
);

const InputDecoration textFieldDecorationDark = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 22.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.tealAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.tealAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
);

// SizedBoxes

const SizedBox kSizedBox15 = SizedBox(height: 15, width: 15);
const SizedBox kSizedBox10 = SizedBox(height: 10, width: 10);
const SizedBox kSizedBox25 = SizedBox(height: 25, width: 25);
const SizedBox kSizedBox12 = SizedBox(height: 12, width: 12);
const SizedBox kSizedBox35 = SizedBox(height: 35, width: 35);
const SizedBox kSizedBox40 = SizedBox(height: 40, width: 40);
const SizedBox kSizedBox30 = SizedBox(height: 30, width: 30);
const SizedBox kSizedBox5 = SizedBox(height: 5, width: 5);
const SizedBox kSizedBox3 = SizedBox(height: 3, width: 3);
const SizedBox kSizedBox20 = SizedBox(height: 20, width: 20);

// light mode colors

const Color kPeachColorLight = Color(0xFFFACDC6);
const Color kPinkColorLight = Color(0xFFFFBBD7);
const Color kOrangeColorLight = Color(0xFFF2A695);
const Color kRedColorLight = Color(0xFFFFAAAA);
const Color kEmberColorLight = Color(0xFFF4B072);
const Color kBrownColorLight = Color(0xFFD6B59C);
const Color kYellowColorLight = Color(0xFFF2DB70);
const Color kGreenColorLight = Color(0xFFCEDE8F);
const Color kTealColorLight = Color(0xFFC2DFD4);
const Color kBlueColorLight = Color(0xFFA3DBE3);
const Color kPurpleColorLight = Color(0xFFD3AEF5);
const Color kGreyColorLight = Color(0xFFCFCFCF);
const Color kWhiteColorLight = Color(0xFFFAFAFA);

const List<Color> kLightColorList = [
  kWhiteColorLight,
  kGreyColorLight,
  kPeachColorLight,
  kPinkColorLight,
  kOrangeColorLight,
  kRedColorLight,
  kEmberColorLight,
  kBrownColorLight,
  kYellowColorLight,
  kGreenColorLight,
  kBlueColorLight,
  kPurpleColorLight,
];

const Color kLightBackground = Color(0xFFFAFAFA);
const Color kFABColorLight = Color(0xFF303030);
const Color kBottomBarColorLight = Color(0xFFDEDEDE);
const Color kProfileListTileTextColorLight = Color(0xFF070707);
const Color kProfileListTileIconColorLight = Color(0xFF656565);
const Color kBiometCardLight = Color(0xFF53A9EF);

// Dark Mode Colors

const Color kDarkBackground = Color(0xFF2E2E2E);
const Color kBottomBarColorDark = Color(0xFF777777);
const Color kProfileListTileTextColorDark = Color(0xFFDFDFDF);
const Color kFABColorDark = Color(0xFF686868);
const Color kAppBarButtonColorDark = Color(0xFF5E5E5E);
const Color kProfileListTileIconColorDark = Color(0xFF8B8B8B);
const Color kBiometCardDark = Color(0xFF52D0AA);
const Color kDialogRedDark = Color(0xFFF35C5C);
Color kTextButtonColorDark = Colors.tealAccent.shade700;
Color kElevatedBackgroundDark = Colors.tealAccent.shade700;
const Color kElevatedForegroundDark = Color(0xFF252525);

const Color kPeachColorDark = Color(0xFFD47D6F);
const Color kPinkColorDark = Color(0xFFD36A95);
const Color kOrangeColorDark = Color(0xFFC75940);
const Color kRedColorDark = Color(0xFFC34545);
const Color kEmberColorDark = Color(0xFFC77C39);
const Color kBrownColorDark = Color(0xFF8E572D);
const Color kYellowColorDark = Color(0xFFC6A923);
const Color kGreenColorDark = Color(0xFF9BB533);
const Color kTealColorDark = Color(0xFF409D7A);
const Color kBlueColorDark = Color(0xFF2B96A5);
const Color kPurpleColorDark = Color(0xFF7F42B7);
const Color kGreyColorDark = Color(0xFFA4A4A4);
const Color kWhiteColorDark = Color(0xFFD0D0D0);

const List<Color> kDarkColorList = [
  kWhiteColorDark,
  kGreyColorDark,
  kPeachColorDark,
  kPinkColorDark,
  kOrangeColorDark,
  kRedColorDark,
  kEmberColorDark,
  kBrownColorDark,
  kYellowColorDark,
  kGreenColorDark,
  kBlueColorDark,
  kPurpleColorDark,
];

Color themeAwareTextColor() {
  if (Get.isDarkMode) {
    return Color(0xFFEAEAEA);
  } else {
    return Colors.black;
  }
}

Color themeAwareBackgroundColor() {
  if (Get.isDarkMode) {
    return kDarkBackground;
  } else {
    return kLightBackground;
  }
}
