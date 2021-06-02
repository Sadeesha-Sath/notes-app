import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/screens/app/unlock_archives_screen.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';
import 'package:notes_app/src/ui/widgets/archive_init.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';

class NoteScreen extends StatefulWidget {
  final NoteModel noteModel;
  final String collectionName;

  NoteScreen({required this.noteModel, this.collectionName = "notes"});

  @override
  _NoteScreenState createState() => _NoteScreenState(noteModel: noteModel, collectionName: collectionName);
}

class _NoteScreenState extends State<NoteScreen> {
  _NoteScreenState({this.collectionName = "notes", required this.noteModel});

  NoteModel noteModel;
  String collectionName;

  @override
  Widget build(BuildContext context) {
    bool isArchived = (collectionName == 'archives');
    bool isInTrash = collectionName == 'trash';
    // TODO In trash, only restore and delete permenently works, and they are on the main app bar
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: Colors.white,
        actions: [
          AppbarButton(icon: Icons.edit, onTap: () {}),
          AppbarButton(icon: Icons.search_rounded, onTap: () {}),
          if (isArchived)
            AppbarButton(
                icon: noteModel.isFavourite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                onTap: () {
                  noteModel.isFavourite = !noteModel.isFavourite;
                  Database().updateFavourite(
                    uid: Get.find<UserController>().user!.uid,
                    noteId: noteModel.noteId,
                    isFavourite: noteModel.isFavourite,
                  );
                }),
          // isArchived
          //     ? Container()
          //     : AppbarButton(
          //         icon: noteModel.isFavourite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
          //         onTap: () {
          //           noteModel.isFavourite = !noteModel.isFavourite;
          //           Database().updateFavourite(
          //             uid: Get.find<UserController>().user!.uid,
          //             collectionName: collectionName,
          //             noteId: noteModel.noteId,
          //             isFavourite: noteModel.isFavourite,
          //           );
          //         }),
          AppbarButton(popupMenuButton: _popupMenuButton(isArchived)),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width / 20, vertical: Get.height / 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text(
              noteModel.title ?? "[No Title]",
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              noteModel.getDateCreated,
              style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15),
            Text(
              noteModel.body ?? "[No Text]",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade900),
              maxLines: null,
              strutStyle: StrutStyle(fontSize: 21.5),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton _popupMenuButton(bool isArchived) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case "Send to Archive":
            // Add to Archive
            // TODO Add confirmation dialog/ bottom sheet
            if (Get.find<UserController>().isPinSet()) {
              setState(() {
                collectionName = 'archives';
              });
              Database().transferNote(
                  uid: Get.find<UserController>().user!.uid,
                  toCollection: 'archives',
                  fromCollection: 'notes',
                  noteId: noteModel.noteId,
                  noteModel: noteModel);
            } else {
              Get.toNamed(UnlockArchivesScreen.id, arguments: {"noteModel": noteModel});
              Get.snackbar("Archive not initialized yet",
                  "Initialize archive to lock your note. Don't worry, your note will be saved and transferred when you finsh setting up");
              
            }
            break;
          case "Make normal":
            // Remove from Archive
            // TODO Add confirmation and biometric auth
            setState(() {
              collectionName = 'notes';
            });
            Database().transferNote(
                uid: Get.find<UserController>().user!.uid,
                toCollection: 'archives',
                fromCollection: 'notes',
                noteId: noteModel.noteId,
                noteModel: noteModel);
            break;
          case "Send to Trash":
            // Add to Trash
            Database().transferNote(
                uid: Get.find<UserController>().user!.uid,
                toCollection: 'trash',
                fromCollection: collectionName,
                noteId: noteModel.noteId,
                noteModel: noteModel);
            Get.back();
            break;
          case "Delete Forever":
            // Add to Trash
            Database().deleteNote(
              uid: Get.find<UserController>().user!.uid,
              collectionName: 'archives',
              noteId: noteModel.noteId,
            );
            Get.back();
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return {
          {
            'text': isArchived ? 'Make Normal' : 'Send to Archive',
            'iconData': isArchived ? CupertinoIcons.lock_slash_fill : CupertinoIcons.lock_fill,
            "color": Colors.grey.shade800
          },
          {
            'text': isArchived ? 'Delete Forever' : 'Send to Trash',
            'iconData': isArchived ? Icons.delete_forever_rounded : Icons.delete_rounded,
            'color': Colors.redAccent
          }
        }.map((Map<String, dynamic> choice) {
          return PopupMenuItem<String>(
            value: choice['text'],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  choice['iconData'],
                  color: choice['color'],
                ),
                Text(
                  choice['text'],
                  style: TextStyle(color: choice['color']),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
