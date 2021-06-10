import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/ui/screens/app/profile_screen.dart';
import 'package:notes_app/src/ui/screens/app/unlock_locked_notes_screen.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';

class HomeScreenAppbar extends StatelessWidget {
  const HomeScreenAppbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      shadowColor: Colors.white,
      foregroundColor: Colors.black,
      pinned: true,
      // floating: true,
      expandedHeight: 170,
      backgroundColor: Color(0xFFFAFAFA),
      actions: [
        AppbarButton(
          onTap: () {},
          icon: Icons.search_rounded,
        ),
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
          child: GetX<NotesController>(
            init: Get.find<NotesController>(),
            builder: (NotesController notesController) {
              if (notesController.notes != null) {
                if (notesController.notes!.isNotEmpty) {
                  if (notesController.notes!.length == 1) {
                    return Text(
                      "1 Note",
                      style: TextStyle(color: Colors.black, fontSize: 33),
                    );
                  }
                  return Text(
                    "${notesController.notes!.length} Notes",
                    style: TextStyle(color: Colors.black, fontSize: 33),
                  );
                } else {
                  return Text(
                    "No Notes Yet",
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  );
                }
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
