import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class CustomBackButton extends StatelessWidget {
  CustomBackButton({Key? key, this.onTap}) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 25,
      icon: Icon(
        CupertinoIcons.arrow_turn_up_left,
        color: Get.isDarkMode ? kLightBackground : Colors.black,
      ),
      onPressed: onTap ?? () => Get.back(),
    );
  }
}
