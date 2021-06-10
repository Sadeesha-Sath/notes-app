import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/locked_screen_controller.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/methods/show_custom_bottom_sheet.dart';
import 'package:notes_app/src/models/mode_enum.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/platform_aware_widgets/platform_alert_dialog.dart';
import 'package:notes_app/src/ui/screens/app/note_screen.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';
import 'package:notes_app/src/ui/widgets/locked_note_card.dart';

class LockedNotesScreen extends GetView<NotesController> {
  static final String id = "/locked_notes";
  final _lockedScreenController = LockedScreenController();
  @override
  Widget build(BuildContext context) {
    controller.bindLocked();
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Get.width / 20, vertical: Get.height / 45),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: Container(),
                elevation: 0,
                shadowColor: Colors.white,
                foregroundColor: Colors.black,
                pinned: true,
                expandedHeight: 170,
                backgroundColor: Color(0xFFFAFAFA),
                actions: [
                  AppbarButton(
                    onTap: () async {
                      if (_lockedScreenController.selectedItems.isNotEmpty) {
                        var value = await PlatformAlertDialog(
                          title: "Confirm Unlock",
                          cancelText: "Cancel",
                          confirmText: "Unlock",
                          content: _lockedScreenController.selectedItems.length > 1
                              ? "Do you want to unlock these notes?"
                              : "Do you want to unlock this note?",
                          confirmColor: Colors.greenAccent.shade700,
                        ).show(context);

                        if (value) {
                          var response = await showCustomModalBottomSheet(context, mode: Mode.pinWithBiometrics);
                          if (response != null && response) {
                            var selectedList = _lockedScreenController.selectedItems.toList();
                            selectedList.sort();
                            for (int index in selectedList.reversed) {
                              Database.transferNote(
                                uid: Get.find<UserController>().userModel!.uid,
                                toCollection: 'notes',
                                fromCollection: 'locked',
                                noteModel: controller.lockedNotes![index],
                              );
                            }
                            _lockedScreenController.selectMode.value = false;
                            _lockedScreenController.selectedItems.clear();
                          }
                        }
                      } else {
                        if (controller.lockedNotes!.isEmpty)
                          Get.snackbar(
                              "No notes in Protected Space", "There are no notes in Protected Space to unlock.",
                              snackPosition: SnackPosition.BOTTOM);
                        else
                          Get.snackbar("No Items Selected", "There is no selected item to unlock.",
                              snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                    icon: CupertinoIcons.lock_slash_fill,
                  ),
                  AppbarButton(
                    onTap: () async {
                      if (_lockedScreenController.selectedItems.isNotEmpty) {
                        var value = await PlatformAlertDialog(
                          title: "Confirm Delte",
                          cancelText: "Cancel",
                          confirmText: "Delete Forever",
                          content: _lockedScreenController.selectedItems.length > 1
                              ? "Do you want to delete these notes? You won't be able to recover them."
                              : "Do you want to delete this note? You won't be able to recover it.",
                          confirmColor: Colors.redAccent,
                        ).show(context);

                        if (value) {
                          var response = await showCustomModalBottomSheet(context, mode: Mode.pinWithBiometrics);
                          if (response != null && response) {
                            var selectedList = _lockedScreenController.selectedItems.toList();
                            selectedList.sort();
                            for (int index in selectedList.reversed) {
                              Database.deleteNote(
                                uid: Get.find<UserController>().userModel!.uid,
                                noteId: controller.lockedNotes![index].noteId!,
                              );
                            }
                            _lockedScreenController.selectMode.value = false;
                            _lockedScreenController.selectedItems.clear();
                          }
                        }
                      } else {
                        if (controller.lockedNotes!.isEmpty)
                          Get.snackbar("No notes in Protected Space", "There are no notes in Protectd Space to delete.",
                              snackPosition: SnackPosition.BOTTOM);
                        else
                          Get.snackbar("No Items Selected", "There is no selected item to delete.",
                              snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                    customIcon: Icon(
                      CupertinoIcons.trash_fill,
                      size: 27,
                      color: Colors.red.shade200,
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  titlePadding: EdgeInsets.only(bottom: 10),
                  title: GetX<NotesController>(
                    init: Get.find<NotesController>(),
                    builder: (NotesController notesController) {
                      if (notesController.lockedNotes != null) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              (notesController.lockedNotes!.isNotEmpty)
                                  ? notesController.lockedNotes!.length == 1
                                      ? "1 Note"
                                      : "${notesController.lockedNotes!.length} Notes"
                                  : "No Secrets",
                              style: TextStyle(color: Colors.black, fontSize: 33),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Icon(
                              CupertinoIcons.lock_fill,
                              size: (notesController.lockedNotes!.isNotEmpty) ? 32 : 29,
                            )
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              // TODO Refractor this and home screen
              GetX<NotesController>(
                  init: Get.find<NotesController>(),
                  builder: (NotesController notesController) {
                    if (notesController.lockedNotes != null) {
                      if (notesController.lockedNotes!.isNotEmpty) {
                        return SliverGrid.count(
                          crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
                          childAspectRatio: 1,
                          children: notesController.lockedNotes!.map((model) {
                            int index = notesController.lockedNotes!.indexOf(model);
                            return GestureDetector(
                              onTap: () {
                                if (_lockedScreenController.selectMode.value) {
                                  // add/remove selected
                                  _lockedScreenController.toggleCheckbox(
                                      !_lockedScreenController.getBool(index), index);
                                } else {
                                  Get.to(
                                    () => NoteScreen(
                                      noteModel: model,
                                      collectionName: 'locked',
                                    ),
                                  );
                                }
                              },
                              onLongPress: () {
                                _lockedScreenController.toggleMode();
                                _lockedScreenController.toggleCheckbox(!_lockedScreenController.getBool(index), index);
                              },
                              child: Obx(
                                () => _lockedScreenController.selectMode.value
                                    ? Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Checkbox(
                                                onChanged: (value) {
                                                  _lockedScreenController.toggleCheckbox(
                                                      value ?? !_lockedScreenController.getBool(index), index);
                                                },
                                                value: _lockedScreenController.getBool(index),
                                              ),
                                            ),
                                            Container(
                                              child: NoteCard(
                                                model,
                                                size: Get.width / 3,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        child: Container(margin: EdgeInsets.all(7.5), child: NoteCard(model)),
                                      ),
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        // No Notes yet
                        return SliverToBoxAdapter(
                          child: Container(
                            decoration:
                                BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                "No secret notes yet. Send an existing note to Protected-Space to get started",
                                style: TextStyle(fontSize: 18),
                                strutStyle: StrutStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
