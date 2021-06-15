import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/ui/screens/app/profile_screen.dart';
import 'package:notes_app/src/ui/screens/app/unlock_locked_notes_screen.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';

class HomeScreenAppbar extends StatelessWidget {
  const HomeScreenAppbar({Key? key, required this.notesController}) : super(key: key);
  final NotesController notesController;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      shadowColor: Colors.white,
      pinned: true,
      expandedHeight: 170,
      backgroundColor: Color(0xFFFAFAFA),
      actions: [
        AppbarButton(
          onTap: () => Get.toNamed(UnlockLockedNotesScreen.id),
          icon: CupertinoIcons.lock_fill,
        ),
        AppbarButton(
          onTap: () => Get.toNamed(ProfileScreen.id),
          icon: Icons.person,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(bottom: 10),
        title: Container(
          child: (notesController.notes!.length == 1)
              ? Text(
                  "1 Note",
                  style: TextStyle(color: Colors.black, fontSize: 33),
                )
              : Text(
                  "${notesController.notes!.length} Notes",
                  style: TextStyle(color: Colors.black, fontSize: 33),
                ),
        ),
      ),
    );
  }
}
