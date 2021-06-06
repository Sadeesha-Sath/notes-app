import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  CustomBackButton({Key? key, this.onTap}) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 25,
      icon: Icon(
        CupertinoIcons.arrow_turn_up_left,
        color: Colors.black,
      ),
      onPressed: onTap ?? () => Get.back(),
    );
  }
}
