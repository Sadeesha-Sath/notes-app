import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/screens/app/trash_screen.dart';
import 'package:notes_app/src/ui/screens/app/unlock_locked_notes_screen.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/profile_screen_listtile.dart';

class ContentsSection extends StatelessWidget {
  const ContentsSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ProfileScreenListTile(
            title: "Favourites",
            icon: Icons.favorite_rounded,
            onTap: () {},
          ),
          ProfileScreenListTile(
            title: "Protected Space",
            icon: CupertinoIcons.lock_fill,
            onTap: () => Get.toNamed(UnlockLockedNotesScreen.id),
          ),
          ProfileScreenListTile(
            title: "Trash",
            icon: Icons.delete_rounded,
            onTap: () {
              Get.toNamed(TrashScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
