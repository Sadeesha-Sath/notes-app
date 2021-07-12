import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/controllers/rating_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/ui/screens/app/note_screen.dart';
import 'package:notes_app/src/ui/screens/app/profile_screen.dart';
import 'package:notes_app/src/ui/screens/app/unlock_locked_notes_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';
import 'package:notes_app/src/ui/widgets/dismissable_note_card.dart';
import 'package:notes_app/src/ui/widgets/home_screen_appbar.dart';

class HomeScreen extends StatelessWidget {
  static final String id = "/home";
  

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserController());
    Get.lazyPut(() => NotesController());
    Get.lazyPut<RatingController>(() => RatingController());
    final ratingController = Get.find<RatingController>();

    if (!ratingController.initialized) {
      ratingController.onInit();
    }

    return Scaffold(
      backgroundColor: themeAwareBackgroundColor(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.isDarkMode ? kFABColorDark : kFABColorLight,
        onPressed: () {
          Get.to(() => NoteScreen.newNote(), transition: Transition.downToUp);
        },
        child: Icon(
          CupertinoIcons.add,
          size: 30,
          color: Get.isDarkMode ? Color(0xFFE9E9E9) : null,
        ),
      ),
      body: GetX<NotesController>(
        init: Get.find<NotesController>(),
        builder: (NotesController notesController) {
          if (notesController.notes != null) {
            if (notesController.notes!.isNotEmpty) {
              return SafeArea(
                top: false,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Get.width / 20, vertical: Get.height / 45),
                  child: CustomScrollView(
                    slivers: [
                      HomeScreenAppbar(
                        notesController: notesController,
                      ),
                      SliverToBoxAdapter(
                        child: kSizedBox10,
                      ),
                      BodyGrid(),
                    ],
                  ),
                ),
              );
            } else {
              // No Notes yet
              return SafeArea(
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: themeAwareBackgroundColor(),
                      title: Text(
                        "Home",
                        style: TextStyle(color: themeAwareTextColor()),
                      ),
                      actions: [
                        AppbarButton(
                          onTap: () => Get.toNamed(UnlockLockedNotesScreen.id),
                          icon: CupertinoIcons.lock_fill,
                        ),
                        AppbarButton(
                          onTap: () => Get.toNamed(ProfileScreen.id),
                          icon: Icons.person,
                        ),
                      ],
                    ),
                    Spacer(),
                    SvgPicture.asset(
                      Get.isDarkMode ? 'assets/empty_home_dark.svg' : 'assets/empty_home.svg',
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Text("No notes yet. Let's be a tad more productive, shall we?",
                          textAlign: TextAlign.center,
                          strutStyle: StrutStyle(fontSize: 22),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Get.isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600)),
                    ),
                    Spacer(),
                  ],
                ),
              );
            }
          } else {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  kSizedBox30,
                  Container(
                    child: Text(
                      "Loading...",
                      style:
                          TextStyle(fontSize: 16, color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade800),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class BodyGrid extends StatelessWidget {
  const BodyGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
      childAspectRatio: 1,
      children: Get.find<NotesController>().notes!.map((model) {
        return Container(
          margin: EdgeInsets.all(7.5),
          child: GestureDetector(
            onTap: () {
              Get.to(
                () => NoteScreen(
                  noteModel: model,
                ),
                transition: Transition.downToUp,
              );
            },
            child: DismissableNoteCard(model),
          ),
        );
      }).toList(),
    );
  }
}
