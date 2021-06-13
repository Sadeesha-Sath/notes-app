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
const Color kOrangeColorLight = Color(0xFFF2907A);
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
