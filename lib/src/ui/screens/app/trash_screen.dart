import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/controllers/trash_screen_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/helpers/content_trimmer.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/platform_aware_widgets/platform_alert_dialog.dart';
import 'package:notes_app/src/ui/screens/app/note_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';

class TrashScreen extends GetView<NotesController> {
  static final String id = "/profile/trash";
  final TrashScreenController _trashScreenController = Get.put(TrashScreenController());

  @override
  Widget build(BuildContext context) {
    controller.bindTrash();
    return Scaffold(
        backgroundColor: themeAwareBackgroundColor(),
        appBar: AppBar(
          backgroundColor: themeAwareBackgroundColor(),
          title: Row(
            children: [
              Text(
                "Trash",
                style: TextStyle(
                  color: themeAwareTextColor(),
                ),
              ),
              kSizedBox10,
              Icon(
                CupertinoIcons.trash,
                color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade800,
              ),
            ],
          ),
          actions: [
            AppbarButton(
              keepSameColor: true,
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
                } else {
                  if (controller.deletedNotes!.isEmpty)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("No Notes in Trash."),
                      ),
                    );
                  else
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("No Items Selected."),
                      ),
                    );
                }
              },
            ),
            AppbarButton(
              keepSameColor: true,
              customIcon: Icon(
                CupertinoIcons.trash_fill,
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
                } else {
                  if (controller.deletedNotes!.isEmpty)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("No Notes in Trash."),
                      ),
                    );
                  else
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("No Items Selected."),
                      ),
                    );
                }
              },
            ),
            kSizedBox5
          ],
          leading: CustomBackButton(),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: GetX<NotesController>(
            init: Get.find<NotesController>(),
            builder: (NotesController notesController) {
              if (notesController.deletedNotes != null) {
                if (notesController.deletedNotes!.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      NoteModel note = notesController.deletedNotes![index];
                      return ListTile(
                        horizontalTitleGap: 25,
                        leading: Obx(
                          () => Checkbox(
                              activeColor: Get.isDarkMode ? Colors.tealAccent.shade700 : null,
                              value: _trashScreenController.getBool(index),
                              onChanged: (bool? value) => _trashScreenController.toggleCheckbox(value!, index)),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 3) + EdgeInsets.only(right: 10),
                        title: Text(
                          ContentTrimmer.trimmer(note.title) ?? ContentTrimmer.trimmer(note.body) ?? "[No Contents]",
                          style: TextStyle(
                              fontSize: 18.5,
                              fontWeight: FontWeight.w600,
                              color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade800),
                        ),
                        onTap: () {
                          Get.to(
                            () => NoteScreen(noteModel: note, collectionName: 'trash'),
                            transition: Transition.rightToLeft,
                            duration: Duration(milliseconds: 330),
                            curve: Curves.easeInOut,
                          );
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
                return Container(
                  padding: EdgeInsets.all(Get.height / 30),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Get.isDarkMode ? 'assets/trash_dark.svg' : 'assets/trash.svg',
                          height: 1.1 * Get.height / 3,
                        ),
                        kSizedBox30,
                        Text(
                          "Looks like you are all cleaned up!",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Get.isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Center(child: CircularProgressIndicator.adaptive());
            },
          ),
        ));
  }
}
