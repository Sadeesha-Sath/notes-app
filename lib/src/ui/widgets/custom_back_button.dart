import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 25,
      icon: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black,),
      onPressed: () => Get.back(),
    );
  }
}
