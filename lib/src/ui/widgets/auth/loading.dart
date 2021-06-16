import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeAwareBackgroundColor(),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: CircularProgressIndicator.adaptive(),
            ),
            kSizedBox30,
            Container(
              child: Text(
                "Loading...",
                style: TextStyle(fontSize: 16, color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade800),
              ),
            )
          ],
        ),
      ),
    );
  }
}
