import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/ui/screens/app/note_screen.dart';
import 'package:notes_app/src/ui/screens/app/pin_set_screen.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';
import 'package:notes_app/src/ui/widgets/biometric_box.dart';
import 'package:notes_app/src/ui/widgets/continue_button.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';

class ArchivesScreen extends GetView<UserController> {
  static final String id = "/archives";
  @override
  Widget build(BuildContext context) {
    Get.find<NotesController>().bindArchives();
    return Scaffold(
      body: SafeArea(
        child: controller.isPinSet()
            ? SafeArea(
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
                            onTap: () => Get.toNamed(ArchivesScreen.id),
                            icon: CupertinoIcons.lock_slash_fill,
                          ),
                          AppbarButton(
                            onTap: () {},
                            customIcon: Icon(
                              Icons.delete_forever_rounded,
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
                              if (notesController.notes != null) {
                                if (notesController.notes!.isNotEmpty) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        "${notesController.notes!.length} Notes",
                                        style: TextStyle(color: Colors.black, fontSize: 33),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Icon(
                                        CupertinoIcons.lock_fill,
                                        size: 32,
                                      )
                                    ],
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
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                      // TODO Refractor this and home screen
                      GetX<NotesController>(
                          init: Get.find<NotesController>(),
                          builder: (NotesController notesController) {
                            // notesController.bindArchives();
                            if (notesController.archivedNotes != null) {
                              if (notesController.archivedNotes!.isNotEmpty) {
                                return SliverGrid.count(
                                  crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
                                  childAspectRatio: 1,
                                  children: notesController.archivedNotes!.map((e) {
                                    return Container(
                                      margin: EdgeInsets.all(7.5),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(() => NoteScreen(
                                                noteModel: e,
                                                collectionName: 'archives',
                                              ));
                                        },
                                        child: Material(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          clipBehavior: Clip.hardEdge,
                                          color: Colors.blue,
                                          elevation: 1,
                                          child: Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                              children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    e.title,
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
                                    );
                                  }).toList(),
                                );
                              } else {
                                // No Notes yet
                                return SliverToBoxAdapter(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300, borderRadius: BorderRadius.circular(20)),
                                    padding: EdgeInsets.all(20),
                                    margin: EdgeInsets.symmetric(vertical: 20),
                                    child: Center(
                                      child: Text(
                                        "No secret notes yet. Send an existing note to Archives to get started",
                                        style: TextStyle(fontSize: 18),
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
              )
            : FirstTime(),
      ),
    );
  }
}

class FirstTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 42 * Get.height / 45,
        padding: EdgeInsets.symmetric(horizontal: Get.width / 30, vertical: Get.height / 45),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: CustomBackButton(),
            ),
            CircleAvatar(
              radius: 120,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width / 60),
              child: Text(
                "Keep your personal notes to yourself",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width / 60),
              child: Text(
                "A secure, encrypted space for your most Confidential notes. Unlocked and decrypted only by a pin or your biometrics. Set up a pin to get started.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Spacer(),
            BiometricBox(
              key: ValueKey('biometricBox'),
            ),
            Spacer(),
            ContinueButton(
              onPressed: () {
                Get.toNamed(PinSetScreen.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
