import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/ui/screens/app/note_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/dismissable_note_card.dart';
import 'package:notes_app/src/ui/widgets/home_screen_appbar.dart';

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
          Get.to(() => NoteScreen.newNote(), transition: Transition.downToUp);
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
              HomeScreenAppbar(),
              SliverToBoxAdapter(
                child: kSizedBox10,
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
