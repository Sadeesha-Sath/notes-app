import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/favourite_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/helpers/content_trimmer.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/platform_aware_widgets/platform_alert_dialog.dart';
import 'package:notes_app/src/ui/screens/app/note_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';

GlobalKey<ScaffoldState> _key = GlobalKey();

class FavouritesScreen extends StatelessWidget {
  static final String id = "/favourites";

  final controller = Get.put(FavouritesController());

  @override
  Widget build(BuildContext context) {
    var favourites = controller.favourites;
    return Scaffold(
      backgroundColor: themeAwareBackgroundColor(),
      key: _key,
      appBar: AppBar(
        backgroundColor: themeAwareBackgroundColor(),
        leading: CustomBackButton(),
        title: Row(
          children: [
            Text(
              "Favourites",
              style: TextStyle(
                color: themeAwareTextColor(),
              ),
            ),
            kSizedBox10,
            Icon(
              CupertinoIcons.heart,
              color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade800,
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 5),
            child: AppbarButton(
              icon: CupertinoIcons.heart_slash,
              onTap: () async {
                if (controller.selectedItems.isNotEmpty) {
                  if (controller.selectedItems.isNotEmpty) {
                    var value = await PlatformAlertDialog(
                      title: "Confirm Remove from Favourites",
                      cancelText: "Cancel",
                      confirmText: "Remove",
                      content: controller.selectedItems.length > 1
                          ? "Do you want to remove these notes from favourites?"
                          : "Do you want to remove this note from favourites?",
                      confirmColor: Colors.redAccent,
                    ).show(context);

                    if (value) {
                      var selectedList = controller.selectedItems.toList();

                      selectedList.sort();
                      for (int index in selectedList.reversed) {
                        await Database.updateFavourite(
                          uid: Get.find<UserController>().userModel!.uid,
                          isFavourite: false,
                          noteId: favourites[index].noteId!,
                        );
                        controller.removeNote(index);
                      }
                      controller.clearSelectedItems();
                    }
                  }
                } else {
                  if (favourites.isEmpty){

                    ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No Favourite Notes")));
                  }
                  else {

                    ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No notes selected")));
                  }
                }
              },
            ),
          )
        ],
      ),
      body: Obx(
        () => Container(
          padding: EdgeInsets.all(10),
          child: (favourites.isNotEmpty)
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    NoteModel note = favourites[index];
                    return Dismissible(
                      dismissThresholds: {DismissDirection.endToStart: 0.45, DismissDirection.startToEnd: 0.45},
                      onDismissed: (direction) async {
                        var noteId = note.noteId!;
                        if (direction == DismissDirection.startToEnd) {
                          controller.removeNote(index);
                          await Database.updateFavourite(
                            uid: Get.find<UserController>().user!.uid,
                            noteId: noteId,
                            isFavourite: false,
                          );
                          restoreFavouriteSnackbar(
                              context,
                              NoteModel(
                                  noteId: noteId,
                                  dateCreated: note.dateCreated,
                                  isFavourite: note.isFavourite,
                                  body: note.body,
                                  title: note.title,
                                  color: note.color),
                              index);
                        } else if (direction == DismissDirection.endToStart) {
                          controller.removeNote(index);
                          await Database.transferNote(
                              uid: Get.find<UserController>().user!.uid,
                              toCollection: 'trash',
                              fromCollection: 'notes',
                              noteModel: note);

                          moveToNotesSnackbar(
                              context,
                              NoteModel(
                                noteId: noteId,
                                dateCreated: note.dateCreated,
                                isFavourite: note.isFavourite,
                                body: note.body,
                                title: note.title,
                                color: note.color,
                              ),
                              index);
                        }
                      },
                      key: ValueKey(note),
                      background: Container(
                        color: Colors.green,
                        child: ListTile(
                          leading: Icon(
                            CupertinoIcons.heart_slash_fill,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.redAccent,
                        child: ListTile(
                          trailing: Icon(
                            CupertinoIcons.trash_fill,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: ListTile(
                        horizontalTitleGap: 25,
                        leading: Obx(
                          () => IconButton(
                            splashRadius: 28,
                            onPressed: () {
                              controller.toggleCheckbox(index);
                            },
                            icon: controller.getBool(index)
                                ? Icon(
                                    CupertinoIcons.heart_slash_fill,
                                    color: Get.isDarkMode ? Colors.tealAccent.shade700 : Colors.grey.shade700,
                                  )
                                : Icon(
                                    CupertinoIcons.heart,
                                    color: Get.isDarkMode ? kProfileListTileIconColorDark : Colors.grey.shade700,
                                  ),
                          ),
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
                            () => NoteScreen(noteModel: note),
                            transition: Transition.rightToLeft,
                            duration: Duration(milliseconds: 330),
                            curve: Curves.easeInOut,
                          );
                        },
                        onLongPress: () {
                          controller.toggleCheckbox(index);
                        },
                        trailing: Icon(Icons.arrow_forward_ios_sharp),
                      ),
                    );
                  },
                  itemCount: favourites.length,
                )
              : Container(
                  padding: EdgeInsets.all(Get.height / 30),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/favourites.svg',
                          height: 80,
                        ),
                        kSizedBox25,
                        Text(
                          "Aww... You don't have any favourites yet. Mark your notes as favourites to find them easier.",
                          style: TextStyle(
                              fontSize: 18.5,
                              fontWeight: FontWeight.w500,
                              color: Get.isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600),
                          strutStyle: StrutStyle(fontSize: 21),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void restoreFavouriteSnackbar(BuildContext context, NoteModel note, int index) {
    ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Note removed from Favourites"),
        action: SnackBarAction(
          onPressed: () async {
            controller.addNote(note, index);
            Database.updateFavourite(
              uid: Get.find<UserController>().user!.uid,
              noteId: note.noteId!,
              isFavourite: true,
            );
          },
          label: "Undo",
        ),
      ),
    );
  }

  void moveToNotesSnackbar(BuildContext context, NoteModel note, int index) {
    ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Note moved to Trash"),
        action: SnackBarAction(
          onPressed: () async {
            controller.addNote(note, index);
            Database.transferNote(
                uid: Get.find<UserController>().user!.uid,
                toCollection: 'notes',
                fromCollection: 'trash',
                noteModel: note);
          },
          label: "Undo",
        ),
      ),
    );
  }
}
