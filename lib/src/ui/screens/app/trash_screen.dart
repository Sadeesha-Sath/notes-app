import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/controllers/trash_screen_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/helpers/content_trimmer.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/platform_aware_widgets/platform_alert_dialog.dart';
import 'package:notes_app/src/ui/screens/app/note_screen.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';

class TrashScreen extends GetView<NotesController> {
  static final String id = "/profile/trash";
  final TrashScreenController _trashScreenController = Get.put(TrashScreenController());

  @override
  Widget build(BuildContext context) {
    controller.bindTrash();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Text(
                "Trash",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.delete_rounded,
                color: Colors.grey.shade800,
              ),
            ],
          ),
          actions: [
            // TODO Find out why the ui doesn't change
            AppbarButton(
              icon: Icons.restore_page_rounded,
              onTap: () async {
                if (_trashScreenController.selectedItems.isNotEmpty) {
                  var value = await PlatformAlertDialog(
                    title: "Confirm Restore",
                    cancelText: "Cancel",
                    confirmText: "Restore",
                    content: _trashScreenController.selectedItems.length > 1
                        ? "Do you want to restore these notes?"
                        : "Do you want to restore this note?",
                    confirmColor: Colors.greenAccent.shade700,
                  ).show(context);

                  if (value) {
                    var trashList = _trashScreenController.selectedItems.toList();
                    trashList.sort();
                    for (int index in trashList.reversed) {
                      Database.transferNote(
                        uid: Get.find<UserController>().userModel!.uid,
                        toCollection: 'notes',
                        fromCollection: 'trash',
                        noteModel: controller.deletedNotes![index],
                      );
                    }
                  }
                }
              },
            ),
            AppbarButton(
              customIcon: Icon(
                Icons.delete_forever_rounded,
                color: Colors.red.shade200,
              ),
              onTap: () async {
                if (_trashScreenController.selectedItems.isNotEmpty) {
                  var value = await PlatformAlertDialog(
                    title: "Confirm Delete",
                    cancelText: "Cancel",
                    confirmText: "Delete",
                    content: _trashScreenController.selectedItems.length > 1
                        ? "Do you want to delete these notes permenently?"
                        : "Do you want to delete this note permenently?",
                    confirmColor: Colors.redAccent,
                  ).show(context);

                  if (value) {
                    var trashList = _trashScreenController.selectedItems.toList();
                    trashList.sort();
                    for (int index in trashList.reversed) {
                      Database.deleteNote(
                        uid: Get.find<UserController>().userModel!.uid,
                        noteId: controller.deletedNotes![index].noteId!,
                      );
                    }
                    _trashScreenController.selectedItems.clear();
                  }
                }
              },
            ),
            SizedBox(
              width: 5,
            )
          ],
          leading: CustomBackButton(),
        ),
        body: GetX<NotesController>(
          init: Get.find<NotesController>(),
          builder: (NotesController notesController) {
            if (notesController.deletedNotes != null) {
              if (notesController.deletedNotes!.isNotEmpty) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    //TODO Add some drag support
                    NoteModel note = notesController.deletedNotes![index];
                    return ListTile(
                      horizontalTitleGap: 25,
                      leading: Obx(
                        () => Checkbox(
                            value: _trashScreenController.getBool(index),
                            onChanged: (bool? value) => _trashScreenController.toggleCheckbox(value!, index)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 3) + EdgeInsets.only(right: 10),
                      title: Text(
                        ContentTrimmer.trimTitle(note.title) ?? ContentTrimmer.trimBody(note.body) ?? "[No Contents]",
                        style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
                      ),
                      onTap: () {
                        Get.to(() => NoteScreen(noteModel: note, collectionName: 'trash'));
                      },
                      onLongPress: () {
                        _trashScreenController.toggleCheckbox(!_trashScreenController.getBool(index), index);
                      },
                      trailing: Icon(Icons.arrow_forward_ios_sharp),
                    );
                  },
                  itemCount: notesController.deletedNotes!.length,
                );
              }
              return Container();
            }
            return CircularProgressIndicator.adaptive();
          },
        )

        // TODO Make a view to accomadate empty trash
        );
  }
}
