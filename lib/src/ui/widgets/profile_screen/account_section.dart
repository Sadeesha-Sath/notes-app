import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/methods/show_custom_bottom_sheet.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/platform_aware_widgets/platform_alert_dialog.dart';
import 'package:notes_app/src/ui/screens/auth/start_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/auth/password_field.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/profile_screen_listtile.dart';

class AccountSection extends GetWidget<UserController> {
  const AccountSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileScreenListTile(
          title: "Delete Account",
          icon: Icons.close_rounded,
          onTap: () async {
            var value = await PlatformAlertDialog(
              title: "Confirm Delete Account",
              cancelText: "Cancel",
              confirmText: "Delete Forever",
              content:
                  "Are you sure about deleting your account? All your data will be deleted and you won't be able to recover them.",
              confirmColor: Colors.redAccent,
            ).show(context, alignment: Alignment.bottomCenter, opacityCurves: Curves.easeOutExpo);

            if (value) {
              var _textController = TextEditingController();
              RxBool hasError = false.obs;
              RxString error = "".obs;
              showModalBottomSheet(
                useRootNavigator: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                context: context,
                builder: (context) => Container(
                  padding: EdgeInsets.all(25),
                  // height: 250,
                  child: Column(
                    children: [
                      Text("Enter your Password to Continue", style: TextStyle(fontSize: 20)),
                      kSizedBox30,
                      PasswordTextField(
                        controller: _textController,
                        key: ValueKey("password"),
                        hintText: "",
                      ),
                      Obx(
                        () => Visibility(
                          visible: hasError.value,
                          child: Container(
                            margin: EdgeInsets.only(top: 25),
                            child: Text(
                              error.value,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.redAccent),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 45),
                      BottomSheetButton(
                        text: "Delete Account",
                        color: Colors.redAccent,
                        onPressed: () async {
                          try {
                            var user = Get.find<UserController>().user!;
                            var _notesController = Get.find<NotesController>();
                            if (_notesController.lockedNotes == null) _notesController.bindLocked();
                            if (_notesController.deletedNotes == null) _notesController.bindTrash();
                            var credential =
                                EmailAuthProvider.credential(email: user.email!, password: _textController.text);
                            await user.reauthenticateWithCredential(credential);
                            await Database.deleteUser(user.uid);
                            await user.delete();
                            Get.offAllNamed(StartScreen.id);
                            print("deleting user");
                          } catch (e) {
                            print(e);
                            hasError(true);
                            try {
                              error(e.toString().split("]")[1]);
                            } on RangeError {
                              error(e.toString());
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          },
          color: Colors.redAccent,
        ),
        ProfileScreenListTile(
          title: "Sign Out",
          icon: Icons.exit_to_app_rounded,
          onTap: () async {
            var value = await PlatformAlertDialog(
              title: "Confirm Sign Out",
              cancelText: "Cancel",
              confirmText: "Sign out",
              content: "Are you sure about signing out from this device?",
              confirmColor: Colors.redAccent,
            ).show(context, alignment: Alignment.bottomCenter);

            if (value) {
              Get.find<FirebaseAuthController>().signOutUser();
            }
          },
          color: Colors.redAccent,
        ),
      ],
    );
  }
}
