import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/ui/screens/app/pin_set_screen.dart';
import 'package:notes_app/src/ui/widgets/biometric_box.dart';
import 'package:notes_app/src/ui/widgets/continue_button.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';

class ArchivesScreen extends GetView<UserController> {
  static final String id = "/archives";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: controller.isPinSet()
            ? Container(
                child: Center(
                  child: Text("Pin Set"),
                ),
              )
            : FirstTime(),
      ),
    );
  }
}

class FirstTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 42 * Get.height / 45,
        padding: EdgeInsets.symmetric(horizontal: Get.width / 30, vertical: Get.height / 45),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: CustomBackButton(),
            ),
            CircleAvatar(
              radius: 120,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width / 60),
              child: Text(
                "Keep Your Notes to with you",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width / 60),
              child: Text(
                "A secure, encrypted space for your most Confidential notes. Unlocked and decrypted only by a pin or your biometrics.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Spacer(),
            BiometricBox(key: ValueKey('biometricBox'),),
            Spacer(),
            ContinueButton(
              onPressed: () {
                Get.toNamed(PinSetScreen.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
