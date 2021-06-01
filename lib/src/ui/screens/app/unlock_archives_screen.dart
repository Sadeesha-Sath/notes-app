import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/ui/widgets/archive_init.dart';

class UnlockArchivesScreen extends StatelessWidget {
  static final String id = "/unlock_archives";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Get.find<UserController>().isPinSet() ?
        // TODO Implement archives pin/biometrics
         Container() :
          ArchiveInit(),
      ),
    );
  }
}
