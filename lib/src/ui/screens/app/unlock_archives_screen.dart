import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/ui/screens/app/archives_screen.dart';
import 'package:notes_app/src/ui/widgets/archive_init.dart';

class UnlockArchivesScreen extends StatelessWidget {
  static final String id = "/unlock_archives";
  final arguments = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Get.find<UserController>().isPinSet()
            ? Center(
                child: ElevatedButton(
                  onPressed: () => Get.offNamed(ArchivesScreen.id),
                  child: Text("TO ARchives"),
                ),
              )

            // TODO Implement archives pin/biometrics
            : ArchiveInit(noteModel: arguments),
      ),
    );
  }
}
