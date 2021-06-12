import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/helpers/color_converter.dart';
import 'package:notes_app/src/helpers/content_trimmer.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/services/database.dart';

class DismissableNoteCard extends StatelessWidget {
  const DismissableNoteCard(
    this.model, {
    Key? key,
  }) : super(key: key);

  final NoteModel model;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      color: ColorConverter.convertColor(model.color),
      elevation: 1,
      child: Dismissible(
        key: ValueKey(model),
        onDismissed: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            await Database.transferNote(
              uid: Get.find<UserController>().user!.uid,
              toCollection: 'locked',
              fromCollection: 'notes',
              noteModel: model,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Note Locked."),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () async {
                    await Database.transferNote(
                      uid: Get.find<UserController>().user!.uid,
                      toCollection: 'notes',
                      fromCollection: 'locked',
                      noteModel: NoteModel(
                        noteId: model.noteId,
                        dateCreated: model.dateCreated,
                        isFavourite: model.isFavourite,
                        body: model.body,
                        title: model.title,
                        color: model.color,
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (direction == DismissDirection.endToStart) {
            await Database.transferNote(
              uid: Get.find<UserController>().user!.uid,
              toCollection: 'trash',
              fromCollection: 'notes',
              noteModel: model,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Note moved to trash."),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () async {
                    await Database.transferNote(
                      uid: Get.find<UserController>().user!.uid,
                      toCollection: 'notes',
                      fromCollection: 'trash',
                      noteModel: NoteModel(
                        noteId: model.noteId,
                        dateCreated: model.dateCreated,
                        isFavourite: model.isFavourite,
                        body: model.body,
                        title: model.title,
                        color: model.color,
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
        background: Container(
          color: Colors.green,
          child: Center(
            child: Icon(
              CupertinoIcons.lock,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        secondaryBackground: Container(
          color: Colors.redAccent,
          child: Center(
            child: Icon(
              CupertinoIcons.trash_fill,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  ContentTrimmer.trimmer(model.title) ?? ContentTrimmer.trimmer(model.body) ?? "[No Content]",
                  strutStyle: StrutStyle(fontSize: 22),
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                ),
              ),
              Spacer(),
              Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  model.getDateCreated,
                  style: TextStyle(fontSize: 17, color: Colors.grey.shade800),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
