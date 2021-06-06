import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/platform_aware_widgets/platform_alert_dialog.dart';
import 'package:notes_app/src/ui/screens/app/unlock_locked_notes_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
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
  _NoteScreenState createState() => _NoteScreenState(
      noteModel: noteModel, collectionName: collectionName, isEditable: isNewNote, isNewNote: isNewNote);
}

class _NoteScreenState extends State<NoteScreen> {
  _NoteScreenState(
      {this.collectionName = "notes", required this.noteModel, required this.isEditable, required this.isNewNote});

  bool isNewNote;
  bool isEditable;
  NoteModel noteModel;
  String collectionName;
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  Widget build(BuildContext context) {
    if (isEditable) {
      _titleController = TextEditingController(text: noteModel.title);
      _bodyController = TextEditingController(text: noteModel.body);
    }
    bool isLocked = collectionName == 'locked';
    bool isInTrash = collectionName == 'trash';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: isEditable
          ? BottomAppBar(
              color: Colors.red,
              shape: CircularNotchedRectangle(),
              child: Container(
                height: 60,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            )
          : null,
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: Colors.white,
        actions: getAppbarActions(isLocked, isInTrash),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width / 20, vertical: Get.height / 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getBodyChildren(),
        ),
      ),
    );
  }

  List<Widget> getBodyChildren() {
    if (isEditable) {
      // Editable body
      // TODO Add some ease in animations to smooth out the transition
      return [
        SizedBox(height: 15),
        TextField(
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
          textAlignVertical: TextAlignVertical.top,
          controller: _titleController,
          textCapitalization: TextCapitalization.sentences,
          decoration: textFieldDecoration.copyWith(
              contentPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              hintText: "Title",
              hintStyle: TextStyle(fontSize: 27, fontWeight: FontWeight.w600)),
          autocorrect: true,
          maxLines: null,
        ),
        SizedBox(height: 15),
        TextField(
          style: TextStyle(fontSize: 18, color: Colors.grey.shade900),
          strutStyle: StrutStyle(fontSize: 21.5),
          controller: _bodyController,
          textAlignVertical: TextAlignVertical.top,
          textCapitalization: TextCapitalization.sentences,
          decoration: textFieldDecoration.copyWith(
            contentPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            hintText: "Text",
            hintStyle: TextStyle(fontSize: 18),
          ),
          autocorrect: true,
          maxLines: null,
        ),
      ];
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
      SizedBox(height: 30),
      Text(
        noteModel.body ?? "[No Text]",
        style: TextStyle(fontSize: 18, color: Colors.grey.shade900),
        maxLines: null,
        strutStyle: StrutStyle(fontSize: 21.5),
      ),
    ];
  }

  List<Widget> getAppbarActions(
    bool isLocked,
    bool isInTrash,
  ) {
    if (isEditable) {
      return [
        Container(
          child: TextButton(
            onPressed: () async {
              if (isNewNote) {
                setState(() {
                  noteModel.title = _titleController.text;
                  noteModel.body = _bodyController.text;
                });
                var newNoteId = await Database.addNote(uid: Get.find<UserController>().userModel!.uid, note: noteModel);
                setState(() {
                  isNewNote = false;
                  isEditable = false;
                  noteModel.noteId = newNoteId;
                });
              } else {
                Database.updateNote(
                  uid: Get.find<UserController>().userModel!.uid,
                  collectionName: collectionName,
                  oldModel: noteModel,
                  newModel: NoteModel(
                    noteId: noteModel.noteId,
                    dateCreated: noteModel.dateCreated,
                    isFavourite: noteModel.isFavourite,
                    title: _titleController.text,
                    body: _bodyController.text,
                  ),
                );
                setState(() {
                  noteModel.title = _titleController.text;
                  noteModel.body = _bodyController.text;
                  isEditable = false;
                });
              }
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.blueAccent, fontSize: 18),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 10),
          child: TextButton(
            onPressed: () {
              if (isNewNote) {
                Get.back();
              } else {
                setState(() {
                  isEditable = false;
                });
              }
            },
            child: Text(
              "Discard",
              style: TextStyle(color: Colors.redAccent, fontSize: 18),
            ),
          ),
        )
      ];
    }
    if (!isInTrash) {
      return [
        AppbarButton(
            icon: Icons.edit,
            onTap: () {
              setState(() {
                isEditable = true;
              });
            }),
        AppbarButton(icon: Icons.search_rounded, onTap: () {}),
        if (!isLocked)
          AppbarButton(
              icon: noteModel.isFavourite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
              onTap: () {
                setState(() {
                  noteModel.isFavourite = !noteModel.isFavourite;
                });
                // When creating a new note, avoid updating the favourites before the note is pushed. It will be pushed with the note content.
                if (noteModel.noteId != null) {
                  Database.updateFavourite(
                    uid: Get.find<UserController>().user!.uid,
                    noteId: noteModel.noteId!,
                    isFavourite: noteModel.isFavourite,
                  );
                }
              }),
        AppbarButton(popupMenuButton: _popupMenuButton(isLocked)),
        SizedBox(width: 5),
      ];
    }
    return [
      AppbarButton(
        icon: Icons.restore_page_rounded,
        onTap: () async {
          var value = await PlatformAlertDialog(
            title: "Confirm Restore",
            cancelText: "Cancel",
            confirmText: "Restore",
            content: "Are you sure about restoring this note?",
            confirmColor: Colors.greenAccent.shade700,
          ).show(context);

          if (value) {
            Database.transferNote(
                uid: Get.find<UserController>().user!.uid,
                toCollection: 'notes',
                fromCollection: 'trash',
                noteModel: noteModel);
          }

          Get.back();
        },
      ),
      AppbarButton(
        customIcon: Icon(
          CupertinoIcons.trash_fill,
          color: Colors.red.shade200,
        ),
        onTap: () async {
          var value = await PlatformAlertDialog(
            title: "Confirm Delete",
            cancelText: "Cancel",
            confirmText: "Delete",
            content: "Do you want to delete this permenantly?",
            confirmColor: Colors.redAccent,
          ).show(context);

          if (value) {
            Database.deleteNote(
              uid: Get.find<UserController>().user!.uid,
              noteId: noteModel.noteId!,
            );
          }

          Get.back();
        },
      ),
      SizedBox(width: 5),
    ];
  }

  PopupMenuButton _popupMenuButton(bool isLocked) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onSelected: (value) async {
        switch (value) {
          case "Lock Note":
            // Add to Protected-Space
            var value = await PlatformAlertDialog(
              title: "Confirm Moving",
              cancelText: "Cancel",
              confirmText: "Move",
              content: "Do you want to lock this note? You will have to use your pin to gain access.",
              confirmColor: Colors.greenAccent.shade700,
            ).show(context);

            if (value) {
              if (Get.find<UserController>().isPinSet()) {
                setState(() {
                  collectionName = 'locked';
                });
                await Database.transferNote(
                  uid: Get.find<UserController>().user!.uid,
                  toCollection: 'locked',
                  fromCollection: 'notes',
                  noteModel: noteModel,
                );
                Get.snackbar("Locking Successful", "The note was locked in the Protected-Space successfully.",
                    snackPosition: SnackPosition.BOTTOM);
              } else {
                Get.toNamed(UnlockLockedNotesScreen.id, arguments: noteModel);
                Get.snackbar("Protcted-Space not initialized yet",
                    "Initialize Protected-Space to lock your note. Don't worry, your note will be saved and transferred when you finsh setting up",
                    duration: Duration(seconds: 3), snackPosition: SnackPosition.BOTTOM);
              }
            }

            break;
          case "Unlock Note":
            // Remove from Protected-Space
            // TODO Add confirmation and biometric auth
            setState(() {
              collectionName = 'notes';
            });
            await Database.transferNote(
              uid: Get.find<UserController>().user!.uid,
              toCollection: 'notes',
              fromCollection: 'locked',
              noteModel: noteModel,
            );
            Get.snackbar("Unlock Successful", "Note was unlocked successfully", snackPosition: SnackPosition.BOTTOM);
            break;
          case "Send to Trash":
            // Add to Trash
            var value = await PlatformAlertDialog(
              title: "Confirm Deleting",
              cancelText: "Cancel",
              confirmText: "Delete",
              content: "Do you want to delete this note? You can restore it from the Trash.",
              confirmColor: Colors.redAccent,
            ).show(context);

            if (value) {
              Database.transferNote(
                uid: Get.find<UserController>().user!.uid,
                toCollection: 'trash',
                fromCollection: collectionName,
                noteModel: noteModel,
              );
              Get.back();
              Get.snackbar("Delete Completed", "The note was sent to Trash successfully.",
                  snackPosition: SnackPosition.BOTTOM);
            }

            break;
          case "Delete Forever":
            // Add to Trash
            var value = await PlatformAlertDialog(
              title: "Confirm Delete",
              cancelText: "Cancel",
              confirmText: "Delete",
              content: "Do you want to delete this permenantly?. You won't be able to restore it.",
              confirmColor: Colors.redAccent,
            ).show(context);

            if (value) {
              Database.deleteNote(
                uid: Get.find<UserController>().user!.uid,
                collectionName: 'locked',
                noteId: noteModel.noteId!,
              );
              Get.back();
              Get.snackbar("Delete Completed", "The note was deleted permenently.",
                  snackPosition: SnackPosition.BOTTOM);
            }
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return {
          {
            'text': isLocked ? 'Unlock Note' : 'Lock Note',
            'iconData': isLocked ? CupertinoIcons.lock_slash_fill : CupertinoIcons.lock_fill,
            "color": Colors.grey.shade800
          },
          {
            'text': isLocked ? 'Delete Forever' : 'Send to Trash',
            'iconData': CupertinoIcons.trash_fill,
            'color': Colors.redAccent
          }
        }.map((Map<String, dynamic> choice) {
          return PopupMenuItem<String>(
            value: choice['text'],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
