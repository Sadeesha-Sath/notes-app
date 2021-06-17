import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/locked_screen_controller.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/methods/show_custom_bottom_sheet.dart';
import 'package:notes_app/src/models/mode_enum.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/platform_aware_widgets/platform_alert_dialog.dart';
import 'package:notes_app/src/ui/screens/app/note_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';
import 'package:notes_app/src/ui/widgets/locked_note_card.dart';

class LockedNotesScreen extends StatelessWidget {
  static final String id = "/locked_notes";
  final _lockedScreenController = LockedScreenController();
  @override
  Widget build(BuildContext context) {
    Get.find<NotesController>().bindLocked();
    return Scaffold(
      backgroundColor: themeAwareBackgroundColor(),
      body: GetX<NotesController>(
          init: Get.find<NotesController>(),
          builder: (NotesController notesController) {
            if (notesController.lockedNotes != null) {
              if (notesController.lockedNotes!.isNotEmpty) {
                return SafeArea(
                  top: false,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: Get.width / 20, vertical: Get.height / 45),
                    child: CustomScrollView(
                      slivers: [
                        LockedScreenAppBar(
                          lockedScreenController: _lockedScreenController,
                          controller: notesController,
                        ),
                        SliverToBoxAdapter(
                          child: kSizedBox10,
                        ),
                        SliverGrid.count(
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
                                    transition: Transition.downToUp,
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
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SafeArea(
                  child: Column(children: [
                    AppBar(
                      centerTitle: true,
                      leadingWidth: 80,
                      leading: CustomBackButton(),
                      backgroundColor: Colors.white,
                      title: Text(
                        "Protected Space",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Spacer(),
                    SvgPicture.asset(
                      'assets/empty_locked.svg',
                      height: Get.height / 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(35),
                      child: Text(
                        "No locked notes yet. Create a note and lock it to ensure that no one can see your data.",
                        textAlign: TextAlign.center,
                        strutStyle: StrutStyle(fontSize: 21),
                        style: TextStyle(
                            fontSize: 19,
                            color: Get.isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Spacer(),
                  ]),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          }),
    );
  }
}

class LockedScreenAppBar extends StatelessWidget {
  const LockedScreenAppBar({
    Key? key,
    required LockedScreenController lockedScreenController,
    required this.controller,
  })  : _lockedScreenController = lockedScreenController,
        super(key: key);

  final LockedScreenController _lockedScreenController;
  final NotesController controller;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: Container(),
      elevation: 0,
      // shadowColor: Colors.white,
      // foregroundColor: Colors.black,
      pinned: true,
      expandedHeight: 170,
      backgroundColor: themeAwareBackgroundColor(),
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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                "No Items were Selected",
              )));
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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                "No Items were Selected",
              )));
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
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              controller.lockedNotes!.length == 1 ? "1 Note" : "${controller.lockedNotes!.length} Notes",
              style: TextStyle(fontSize: 33, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 2),
            Icon(
              CupertinoIcons.lock_fill,
              size: (controller.lockedNotes!.isNotEmpty) ? 32 : 29,
            )
          ],
        ),
      ),
    );
  }
}
