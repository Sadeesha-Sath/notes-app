import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;

  ContinueButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 107 + Get.width / 60),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        ),
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              Spacer(),
              Text(
                "Continue",
                style: TextStyle(fontSize: 17),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
