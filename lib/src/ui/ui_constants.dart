import 'package:flutter/material.dart';

const textFieldDecoration = InputDecoration(
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

// light mode colors

const Color kPeachColorLight = Color(0xFFFACDC6);
const Color kPinkColorLight = Color(0xFFFFAEB0);
const Color kOrangeColorLight = Color(0xFFF2907A);
const Color kRedColorLight = Color(0xFFFFB1BD);
const Color kEmberColorLight = Color(0xFFF4B072);
const Color kBrownColorLight = Color(0xFFD6B59C);
const Color kYellowColorLight = Color(0xFFF2DB70);
const Color kGreenColorLight = Color(0xFFCEDE8F);
const Color kTealColorLight = Color(0xFFC2DFD4);
const Color kBlueColorLight = Color(0xFFA3DBE3);
const Color kPurpleColorLight = Color(0xFFF2DB70);
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
