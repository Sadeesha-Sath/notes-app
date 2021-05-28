import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/archives_auth_controller.dart';
import 'package:notes_app/src/controllers/drag_controller.dart';
import 'package:notes_app/src/ui/screens/app/archives_screen.dart';
import 'package:notes_app/src/ui/screens/app/note_screen.dart';
import 'package:notes_app/src/ui/screens/app/profile_screen.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';

class HomeScreen extends StatelessWidget {
  static final String id = "/home";
  final DragController _dragController = Get.put(DragController());
  // TODO Save and retrieve from the datebase
  final ArchivesAuthController _archivesAuthController = Get.put(ArchivesAuthController());
  @override
  Widget build(BuildContext context) {
    int? draggedId = -1;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF303030),
        onPressed: () {},
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: Container(
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
                  onTap: () => Get.toNamed(ArchivesScreen.id),
                  icon: Icons.archive_rounded,
                ),
                AppbarButton(
                  onTap: () => Get.toNamed(ProfileScreen.id),
                  icon: Icons.person,
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.zero,
                title: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Text(
                    "40 Notes",
                    style: TextStyle(color: Colors.black, fontSize: 33),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 15,
              ),
            ),
            SliverGrid.count(
              crossAxisCount: 2,
              children: List.generate(
                15,
                (index) => Container(
                  margin: EdgeInsets.all(7.5),
                  child: GestureDetector(
                      onTap: () {
                        Get.toNamed(NoteScreen.id);
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
                            _dragController.animationController.value < -1 * (Get.width / 4)) print("Deleted $index");
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
                                      "Hello this is a demo of the Title",
                                      strutStyle: StrutStyle(fontSize: 20),
                                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      "Sun, 19th May",
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
                                            ? _dragController.animationController.value - 2.1 * Get.width / 5
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
                ),
              ),
              childAspectRatio: 1,
            ),
          ],
        ),
      ),
    );
  }
}
