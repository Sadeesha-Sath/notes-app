import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/widgets/auth/password_field.dart';

Future showCustomModalBottomSheet(
  BuildContext context, {
  required TextEditingController textController,
  required String mode,
}) {
  RxInt stage = 1.obs;
  RxBool hasError = false.obs;
  RxString error = "".obs;
  RxString password = "".obs;
  UserController controller = Get.find<UserController>();
  return showModalBottomSheet(
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      // isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(25),
          // height: 250,
          child: Column(
            children: [
              mode == "Name"
                  ? Text("Enter New Name", style: TextStyle(fontSize: 20))
                  : Obx(
                      () => stage.value == 1
                          ? Text("Enter your Password to Continue", style: TextStyle(fontSize: 20))
                          : (mode == "Email")
                              ? Text("Enter your Email", style: TextStyle(fontSize: 20))
                              : stage.value == 2
                                  ? Text(
                                      "Enter New Password",
                                      style: TextStyle(fontSize: 20),
                                    )
                                  : Text(
                                      "Confirm New Password",
                                      style: TextStyle(fontSize: 20),
                                    ),
                    ),
              SizedBox(
                height: 30,
              ),
              mode != "Name" && stage.value == 1 ? PasswordTextField(controller: textController, key: ValueKey('passwordfield'), hintText: "",) :
              TextField(
                obscureText: mode == 'password' || (mode == 'Email') && (stage.value == 1) ? true : false,
                controller: textController,
                style: TextStyle(fontSize: 20),
                decoration: textFieldDecoration.copyWith(hintText: ""),
              ),
              Obx(
                () => hasError.value
                    ? Container(
                        margin: EdgeInsets.only(top: 25),
                        child: Text(
                          error.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.redAccent),
                        ),
                      )
                    : Container(),
              ),
              SizedBox(
                height: 45,
              ),
              (mode == "Name")
                  ? BottomSheetButton(
                      onPressed: () async {
                        try {
                          controller.updateName(textController.text);
                          Database.updateName(controller.user!.uid, textController.text);
                          if (controller.user?.displayName != null) {
                            controller.user!.updateProfile(displayName: textController.text);
                          }
                          Get.back();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Update Successful"),
                              backgroundColor: Colors.blue.shade900,
                            ),
                          );
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Update Unsuccessful"),
                              backgroundColor: Colors.red.shade900,
                            ),
                          );
                        }
                      },
                      text: "Update Name",
                    )
                  : Obx(
                      () => stage.value == 1
                          ? BottomSheetButton(
                              onPressed: () async {
                                try {
                                  var credentials = EmailAuthProvider.credential(
                                    email: controller.user!.email!,
                                    password: textController.text,
                                  );
                                  await controller.user!.reauthenticateWithCredential(credentials);
                                  textController.clear();
                                  hasError(false);
                                  ++stage;
                                } catch (e) {
                                  print(e);
                                  hasError(true);
                                  error("${e.toString().split(']')[1]}");
                                }
                              },
                              text: "Continue",
                            )
                          : (mode == "Email")
                              ? BottomSheetButton(
                                  onPressed: () async {
                                    try {
                                      if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                              caseSensitive: false)
                                          .hasMatch(textController.text)) {
                                        await controller.user!.updateEmail(textController.text);
                                        hasError(false);
                                        textController.clear();

                                        Get.back();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Update Successful"),
                                            backgroundColor: Colors.blue.shade900,
                                          ),
                                        );
                                      } else {
                                        hasError(true);
                                        error("Invalid Email. Please enter a valid email address.");
                                      }
                                    } catch (e) {
                                      print(e);
                                      Get.snackbar(
                                        "Update Unsuccessful",
                                        e.toString(),
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red.shade900,
                                      );
                                    }
                                  },
                                  text: "Update Email",
                                )
                              : (stage.value == 2)
                                  ? BottomSheetButton(
                                      onPressed: () {
                                        password(textController.text);
                                        hasError(false);
                                        textController.clear();
                                        ++stage;
                                      },
                                      text: "Continue",
                                    )
                                  : BottomSheetButton(
                                      onPressed: () async {
                                        try {
                                          if (password.value == textController.text) {
                                            await controller.user!.updatePassword(password.value);
                                            textController.clear();
                                            hasError(false);
                                            Get.back();
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text("Update Successful"),
                                              backgroundColor: Colors.green,
                                            ));
                                          } else {
                                            hasError(true);
                                            error("Passwords don't match. Please try again.");
                                            textController.clear();
                                          }
                                        } catch (e) {
                                          print(e);
                                          hasError(true);
                                          error("${e.toString().split(']')[1]}");
                                          textController.clear();
                                        }
                                      },
                                      text: "Update Password",
                                    ),
                    ),
            ],
          ),
        );
      });
}

class BottomSheetButton extends StatelessWidget {
  const BottomSheetButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.color,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 20, vertical: 12.5),
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }
}
