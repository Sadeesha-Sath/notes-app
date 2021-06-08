import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/helpers/content_trimmer.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/screens/app/note_screen.dart';
import 'package:notes_app/src/ui/screens/app/profile_screen.dart';
import 'package:notes_app/src/ui/screens/app/unlock_locked_notes_screen.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';

class HomeScreen extends StatelessWidget {
  static final String id = "/home";

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserController());
    Get.lazyPut(() => NotesController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF303030),
        onPressed: () {
          Get.to(() => NoteScreen.newNote());
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Get.width / 20, vertical: Get.height / 45),
          child: CustomScrollView(
            slivers: [
              Appbar(),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              GetX<NotesController>(
                init: Get.find<NotesController>(),
                builder: (NotesController notesController) {
                  if (notesController.notes != null) {
                    if (notesController.notes!.isNotEmpty) {
                      return BodyGrid();
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
                              "Looks like you haven't taken a note for a while. Let's be a bit more productive, shall we?",
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
                },
              ),
            ],
          ),
        ),
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
      children: Get.find<NotesController>().notes!.map((e) {
        return Container(
          margin: EdgeInsets.all(7.5),
          child: GestureDetector(
            onTap: () {
              Get.to(
                () => NoteScreen(
                  noteModel: e,
                ),
              );
            },
            child: Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.hardEdge,
              color: Colors.blue,
              elevation: 1,
              child: Dismissible(
                key: ValueKey(e),
                onDismissed: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    await Database.transferNote(
                      uid: Get.find<UserController>().user!.uid,
                      toCollection: 'locked',
                      fromCollection: 'notes',
                      noteModel: e,
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
                                  noteId: e.noteId,
                                  dateCreated: e.dateCreated,
                                  isFavourite: e.isFavourite,
                                  body: e.body,
                                  title: e.title),
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
                      noteModel: e,
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
                                  noteId: e.noteId,
                                  dateCreated: e.dateCreated,
                                  isFavourite: e.isFavourite,
                                  body: e.body,
                                  title: e.title),
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
                          ContentTrimmer.trimTitle(e.title) ?? ContentTrimmer.trimBody(e.body) ?? "[No Content]",
                          strutStyle: StrutStyle(fontSize: 22),
                          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Spacer(),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          e.getDateCreated,
                          style: TextStyle(fontSize: 17, color: Colors.grey.shade800),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class Appbar extends StatelessWidget {
  const Appbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      shadowColor: Colors.white,
      foregroundColor: Colors.black,
      pinned: true,
      // floating: true,
      expandedHeight: 170,
      backgroundColor: Color(0xFFFAFAFA),
      actions: [
        AppbarButton(
          onTap: () {},
          icon: Icons.search_rounded,
        ),
        AppbarButton(
          onTap: () => Get.toNamed(UnlockLockedNotesScreen.id),
          icon: CupertinoIcons.lock_fill,
        ),
        AppbarButton(
          onTap: () => Get.toNamed(ProfileScreen.id),
          icon: Icons.person,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(bottom: 10),
        title: Container(
          child: GetX<NotesController>(
            init: Get.find<NotesController>(),
            builder: (NotesController notesController) {
              if (notesController.notes != null) {
                if (notesController.notes!.isNotEmpty) {
                  if (notesController.notes!.length == 1) {
                    return Text(
                      "1 Note",
                      style: TextStyle(color: Colors.black, fontSize: 33),
                    );
                  }
                  return Text(
                    "${notesController.notes!.length} Notes",
                    style: TextStyle(color: Colors.black, fontSize: 33),
                  );
                } else {
                  return Text(
                    "No Notes Yet",
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  );
                }
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
