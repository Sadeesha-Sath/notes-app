import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SectionSeparator extends StatelessWidget {
  SectionSeparator(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: Get.width / 22),
      color: Get.isDarkMode ? Color(0xFF3A3A3A) : Color(0xFFF6F6F6),
      width: double.infinity,
      child: Text(
        title,
        style: TextStyle(color: Color(0xFF9A9A9A), fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.3),
      ),
      alignment: Alignment.centerLeft,
    );
  }
}
