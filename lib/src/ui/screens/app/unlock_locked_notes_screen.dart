import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/ui/screens/app/locked_notes_screen.dart';
import 'package:notes_app/src/ui/widgets/locked_notes_init.dart';

class UnlockLockedNotesScreen extends StatelessWidget {
  static final String id = "/unlock_locked_notes";
  final arguments = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Get.find<UserController>().isPinSet()
            ? Center(
                child: ElevatedButton(
                  onPressed: () => Get.offNamed(LockedNotesScreen.id),
                  child: Text("TO locked"),
                ),
              )

            // TODO Implement locked pin/biometrics
            : LockedNotesInit(noteModel: arguments),
      ),
    );
  }
}
