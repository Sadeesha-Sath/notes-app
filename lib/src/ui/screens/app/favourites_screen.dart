import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/favourite_controller.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/helpers/content_trimmer.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/platform_aware_widgets/platform_alert_dialog.dart';
import 'package:notes_app/src/ui/screens/app/note_screen.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';

class FavouritesScreen extends GetView<NotesController> {
  static final String id = "/favourites";
  final FavouritesController _favouritesController = Get.put(FavouritesController());

  @override
  Widget build(BuildContext context) {
    var favourites = controller.notes!.where((element) => element.isFavourite == true).toList();
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              "Favourites",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(width: 10),
            Icon(
              CupertinoIcons.heart,
              color: Colors.grey.shade800,
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 5),
            child: AppbarButton(
              icon: CupertinoIcons.heart_slash,
              onTap: () async {
                if (_favouritesController.selectedItems.isNotEmpty) {
                  if (_favouritesController.selectedItems.isNotEmpty) {
                    var value = await PlatformAlertDialog(
                      title: "Confirm Remove from Favourites",
                      cancelText: "Cancel",
                      confirmText: "Remove",
                      content: _favouritesController.selectedItems.length > 1
                          ? "Do you want to remove these notes from favourites?"
                          : "Do you want to remove this note from favourites?",
                      confirmColor: Colors.redAccent,
                    ).show(context);

                    if (value) {
                      var selectedList = _favouritesController.selectedItems.toList();

                      selectedList.sort();
                      for (int index in selectedList.reversed) {
                        Database.updateFavourite(
                          uid: Get.find<UserController>().userModel!.uid,
                          isFavourite: false,
                          noteId: favourites[index].noteId!,
                        );
                      }
                    }
                  }
                } else {
                  if (favourites.isEmpty)
                    Get.snackbar("No notes in Trash", "There are no notes in trash to restore.",
                        snackPosition: SnackPosition.BOTTOM);
                  else
                    Get.snackbar("No Items Selected", "There is no selected item to restore.",
                        snackPosition: SnackPosition.BOTTOM);
                }
              },
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: (favourites.isNotEmpty)
            ? ListView.builder(
                itemBuilder: (context, index) {
                  NoteModel note = favourites[index];
                  return ListTile(
                    horizontalTitleGap: 25,
                    leading: Obx(
                      () =>
                          // Checkbox(
                          //     value: _favouritesController.getBool(index),
                          //     onChanged: (bool? value) => _favouritesController.toggleCheckbox(value!, index)),
                          IconButton(
                        splashRadius: 28,
                        onPressed: () {
                          _favouritesController.toggleCheckbox(index);
                        },
                        icon: Icon(
                          _favouritesController.getBool(index) ? CupertinoIcons.heart_slash_fill : CupertinoIcons.heart,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 3) + EdgeInsets.only(right: 10),
                    title: Text(
                      ContentTrimmer.trimTitle(note.title) ?? ContentTrimmer.trimBody(note.body) ?? "[No Contents]",
                      style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
                    ),
                    onTap: () {
                      Get.to(() => NoteScreen(noteModel: note));
                    },
                    onLongPress: () {
                      _favouritesController.toggleCheckbox(index);
                    },
                    trailing: Icon(Icons.arrow_forward_ios_sharp),
                  );
                },
                itemCount: favourites.length,
              )
            :

            // TODO design this
            Container(
                padding: EdgeInsets.all(Get.height / 30),
                child: Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 100,
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Looks like you are all cleaned up!",
                        style: TextStyle(fontSize: 33, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
