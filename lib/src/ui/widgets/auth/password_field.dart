import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final Key key;
  PasswordTextField({required this.controller, this.hintText, required this.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: ValueBuilder<bool?>(
        initialValue: true,
        builder: (isHidden, updater) => TextField(
          obscureText: isHidden!,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.left,
          controller: controller,
          decoration: (Get.isDarkMode
              ? textFieldDecorationDark
              : textFieldDecorationLight).copyWith(
                  prefixIcon: Icon(Icons.password),
                  suffixIcon: IconButton(
                    splashRadius: 20,
                    onPressed: () => updater(!isHidden),
                    icon: Icon(isHidden ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                  ),
                  hintText: hintText ?? "Enter a password",
                ),
        ),
      ),
    );
  }
}
