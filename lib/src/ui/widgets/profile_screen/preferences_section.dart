import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/ui/screens/app/unlock_locked_notes_screen.dart';
import 'package:notes_app/src/ui/widgets/show_custom_bottom_sheet.dart';
import 'package:notes_app/src/models/mode_enum.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/biometric_list_tile.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/night_mode_listtile.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/profile_screen_listtile.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          NightModeListTile(),
          ProfileScreenListTile(
            title: "Change Protected Space Pin",
            icon: Icons.phonelink_lock_outlined,
            onTap: () {
              if (Get.find<UserController>().isPinSet()) {
                if (Get.find<NotesController>().lockedNotes == null) Get.find<NotesController>().bindLocked();
                var _textController = TextEditingController();
                showCustomModalBottomSheet(context, textController: _textController, mode: Mode.pin);
              } else {
                Get.toNamed(UnlockLockedNotesScreen.id);
              }
            },
          ),
          BiometricListTile(
            key: ValueKey('biometrics'),
          ),
        ],
      ),
    );
  }
}
