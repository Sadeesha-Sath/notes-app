import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double paddingVal;

  ContinueButton({required this.onPressed, this.paddingVal = 107});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingVal + Get.width / 60),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        ),
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              Spacer(
                flex: 5,
              ),
              Text(
                "Continue",
                style: TextStyle(fontSize: 17),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 22,
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
