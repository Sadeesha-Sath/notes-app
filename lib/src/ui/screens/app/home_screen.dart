import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/drag_controller.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/services/encrypter.dart';
import 'package:notes_app/src/ui/screens/app/note_screen.dart';
import 'package:notes_app/src/ui/screens/app/profile_screen.dart';
import 'package:notes_app/src/ui/screens/app/unlock_archives_screen.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';

class HomeScreen extends StatelessWidget {
  static final String id = "/home";
  final DragController _dragController = Get.put(DragController());

  @override
  Widget build(BuildContext context) {

    int? draggedId = -1;
    Get.lazyPut(() => UserController());
    Get.lazyPut(() => NotesController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF303030),
        onPressed: () {},
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
              SliverAppBar(
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
                    onTap: () => Get.toNamed(UnlockArchivesScreen.id),
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
              ),
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
                        return SliverGrid.count(
                          crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
                          childAspectRatio: 1,
                          children: notesController.notes!.map((e) {
                            var index = notesController.notes?.indexOf(e);
                            return Container(
                              margin: EdgeInsets.all(7.5),
                              child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => NoteScreen(
                                          noteModel: e,
                                        ));
                                  },
                                  onHorizontalDragUpdate: (details) {
                                    if (details.primaryDelta != null) {
                                      _dragController.animationController.value += details.primaryDelta!;
                                    }
                                  },
                                  onHorizontalDragStart: (details) => draggedId = index,
                                  onHorizontalDragEnd: (details) {
                                    if (_dragController.animationController.value > Get.width / 4)
                                      print("Archived $index");
                                    else if (_dragController.animationController.value < 0 &&
                                        _dragController.animationController.value < -1 * (Get.width / 4))
                                      print("Deleted $index");
                                    _dragController.animationController.value = 0;
                                  },
                                  child: Material(
                                    // TODO Make Drag Behaviour
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    clipBehavior: Clip.hardEdge,
                                    color: Colors.blue,
                                    elevation: 1,
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  e.title != null
                                                      ? e.title!
                                                      : e.body!.split(" ").length < 9
                                                          ? e.body!.split(" ").join() + "..."
                                                          : e.body!.split(" ").sublist(0, 8).join() + "...",
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
                                        // TODO Refine this and make it responsive
                                        AnimatedBuilder(
                                            animation: _dragController.animationController,
                                            builder: (context, child) {
                                              return Transform.translate(
                                                offset: Offset(
                                                    index == draggedId
                                                        ? _dragController.animationController.value -
                                                            2.1 * Get.width / 5
                                                        : -2.1 * Get.width / 5,
                                                    0),
                                                child: Container(
                                                  color: Colors.green,
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  )),
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
                  })
              // SliverGrid.count(
              //   crossAxisCount: 2,
              // children: List.generate(
              //   15,
              // (index) => Container(
              //   margin: EdgeInsets.all(7.5),
              //   child: GestureDetector(
              //       onTap: () {
              //         Get.to(() => NoteScreen());
              //       },
              //       onHorizontalDragUpdate: (details) {
              //         if (details.primaryDelta != null) {
              //           _dragController.animationController.value += details.primaryDelta!;
              //         }
              //       },
              //       onHorizontalDragStart: (details) => draggedId = index,
              //       onHorizontalDragEnd: (details) {
              //         if (_dragController.animationController.value > Get.width / 4)
              //           print("Archived $index");
              //         else if (_dragController.animationController.value < 0 &&
              //             _dragController.animationController.value < -1 * (Get.width / 4)) print("Deleted $index");
              //         _dragController.animationController.value = 0;
              //       },
              //       child: Material(
              //         // TODO Make Drag Behaviour
              //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              //         clipBehavior: Clip.hardEdge,
              //         color: Colors.blue,
              //         elevation: 1,
              //         child: Stack(
              //           children: [
              //             Padding(
              //               padding: EdgeInsets.all(15),
              //               child: Column(
              //                 children: [
              //                   Container(
              //                     alignment: Alignment.topLeft,
              //                     child: Text(
              //                       "Hello this is a demo of the Title",
              //                       strutStyle: StrutStyle(fontSize: 20),
              //                       style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
              //                     ),
              //                   ),
              //                   Spacer(),
              //                   Container(
              //                     alignment: Alignment.bottomRight,
              //                     child: Text(
              //                       "Sun, 19th May",
              //                       style: TextStyle(fontSize: 17, color: Colors.grey.shade800),
              //                     ),
              //                   )
              //                 ],
              //               ),
              //             ),
              //             // TODO Refine this and make it responsive
              //             AnimatedBuilder(
              //                 animation: _dragController.animationController,
              //                 builder: (context, child) {
              //                   return Transform.translate(
              //                     offset: Offset(
              //                         index == draggedId
              //                             ? _dragController.animationController.value - 2.1 * Get.width / 5
              //                             : -2.1 * Get.width / 5,
              //                         0),
              //                     child: Container(
              //                       color: Colors.green,
              //                     ),
              //                   );
              //                 }),
              //           ],
              //         ),
              //       )),
              // ),
              // ),
              //   childAspectRatio: 1,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
