import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/screens/app/unlock_archives_screen.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';

class NoteScreen extends StatefulWidget {
  final NoteModel noteModel;
  final String collectionName;
  final bool isNewNote;

  NoteScreen({required this.noteModel, this.collectionName = "notes", this.isNewNote = false});
  NoteScreen.newNote({
    this.isNewNote = true,
    this.collectionName = 'notes',
  }) : noteModel = NoteModel(noteId: null, dateCreated: Timestamp.now(), isFavourite: false);

  @override
  _NoteScreenState createState() =>
      _NoteScreenState(noteModel: noteModel, collectionName: collectionName, isEditable: isNewNote);
}

class _NoteScreenState extends State<NoteScreen> {
  _NoteScreenState({this.collectionName = "notes", required this.noteModel, required this.isEditable});

  bool isEditable;
  NoteModel noteModel;
  String collectionName;

  @override
  Widget build(BuildContext context) {
    bool isArchived = (collectionName == 'archives');
    bool isInTrash = collectionName == 'trash';

    // TODO Check the noteModel noteId availability to distinguish between new note and edited note when accessing the database

    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: !isEditable
          ? BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
                  width: 10,
                  height: 10,
                ),
              ),
            )
          : null,
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: Colors.white,
        actions: getAppbarActions(isArchived, isInTrash),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width / 20, vertical: Get.height / 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getBBodyChildren(),
        ),
      ),
    );
  }

  List<Widget> getBBodyChildren() {
    if (isEditable) {
      // Editable body
    }
    return [
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
    ];
  }

  List<Widget> getAppbarActions(bool isArchived, bool isInTrash) {
    if (isEditable) {
      return [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 3),
          child: TextButton(
            onPressed: () {},
            child: Text(
              "Save",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 3),
          child: TextButton(
              onPressed: () {
                setState(() {
                  isEditable = false;
                });
              },
              child: Text(
                "Discard",
                style: TextStyle(color: Colors.redAccent),
              )),
        )
      ];
    }
    if (isInTrash) {
      return [
        AppbarButton(
            icon: Icons.edit,
            onTap: () {
              setState(() {
                isEditable = true;
              });
            }),
        AppbarButton(icon: Icons.search_rounded, onTap: () {}),
        if (isArchived)
          AppbarButton(
              icon: noteModel.isFavourite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
              onTap: () {
                noteModel.isFavourite = !noteModel.isFavourite;
                Database().updateFavourite(
                  uid: Get.find<UserController>().user!.uid,
                  noteId: noteModel.noteId!,
                  isFavourite: noteModel.isFavourite,
                );
              }),
        AppbarButton(popupMenuButton: _popupMenuButton(isArchived)),
      ];
    }
    return [
      AppbarButton(
        icon: Icons.restore_page_rounded,
        onTap: () async {
          // TODO Add confirmations
          Database().transferNote(
              uid: Get.find<UserController>().user!.uid,
              toCollection: 'notes',
              fromCollection: 'trash',
              noteId: noteModel.noteId!,
              noteModel: noteModel);

          Get.back();
        },
      ),
      AppbarButton(
        icon: Icons.delete_forever_rounded,
        onTap: () async {
          // TODO Add confirmations
          Database().deleteNote(uid: Get.find<UserController>().user!.uid, noteId: noteModel.noteId!);

          Get.back();
        },
      )
    ];
  }

  PopupMenuButton _popupMenuButton(bool isArchived) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case "Send to Archive":
            // Add to Archive
            // TODO Add confirmation dialog/ bottom sheet

            // TODO Use snackbars to alert the completation of use actions
            if (Get.find<UserController>().isPinSet()) {
              setState(() {
                collectionName = 'archives';
              });
              Database().transferNote(
                  uid: Get.find<UserController>().user!.uid,
                  toCollection: 'archives',
                  fromCollection: 'notes',
                  noteId: noteModel.noteId!,
                  noteModel: noteModel);
            } else {
              Get.toNamed(UnlockArchivesScreen.id, arguments: noteModel);
              Get.snackbar("Archive not initialized yet",
                  "Initialize archive to lock your note. Don't worry, your note will be saved and transferred when you finsh setting up", duration: Duration(seconds: 3));
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
                noteId: noteModel.noteId!,
                noteModel: noteModel);
            break;
          case "Send to Trash":
            // Add to Trash
            Database().transferNote(
                uid: Get.find<UserController>().user!.uid,
                toCollection: 'trash',
                fromCollection: collectionName,
                noteId: noteModel.noteId!,
                noteModel: noteModel);
            Get.back();
            break;
          case "Delete Forever":
            // Add to Trash
            Database().deleteNote(
              uid: Get.find<UserController>().user!.uid,
              collectionName: 'archives',
              noteId: noteModel.noteId!,
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
