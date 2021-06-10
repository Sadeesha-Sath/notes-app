import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/file_handlers/inherited_preferences.dart';
import 'package:notes_app/src/models/mode_enum.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/screens/app/pin_set_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/widgets/auth/password_field.dart';
import 'package:notes_app/src/ui/widgets/biometric_card.dart';
import 'package:notes_app/src/ui/widgets/continue_button.dart';

Future<bool?> showCustomModalBottomSheet(
  BuildContext context, {
  TextEditingController? textController,
  required Mode mode,
}) {
  final RxInt stage = 1.obs;

  final Rx<String?> error = Rx(null);
  final RxString password = "".obs;
  if (textController == null) {
    textController = TextEditingController();
  }
  return showModalBottomSheet<bool>(
      // useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      // isScrollControlled: true,
      context: context,
      builder: (context) {
        return BottomSheet(mode, textController!, stage, error, password);
      });
}

class BottomSheet extends GetView<UserController> {
  BottomSheet(this.mode, this.textController, this.stage, this.error, this.password);

  final Mode mode;
  final TextEditingController textController;
  final RxInt stage;

  final Rx<String?> error;
  final RxString password;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      // height: 250,
      child: Column(
        children: [
          getTitle(),
          SizedBox(
            height: 30,
          ),
          getTextField(),
          Obx(
            () => Visibility(
              visible: error.value != null,
              child: Container(
                margin: EdgeInsets.only(top: 25),
                child: Text(
                  error.value.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.redAccent),
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Visibility(
              visible: mode == Mode.pinWithBiometrics &&
                  InheritedPreferences.of(context)!.preferences['isBiometricEnabled']!,
              child: BiometricCard(error: error)),
          SizedBox(height: 20),
          getButton(context),
          SizedBox(height: 12),
          if (mode == Mode.pin)
            Obx(
              () => Visibility(
                visible: stage.value == 1,
                child: TextButton(
                  onPressed: () {
                    ++stage.value;
                  },
                  child: Text(
                    "Forgot Pin?",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget getTitle() {
    if (mode == Mode.name)
      return Text("Enter New Name", style: TextStyle(fontSize: 20));
    else if (mode == Mode.pinWithBiometrics)
      return Text(
        "Enter your Current Pin to Continue",
        style: TextStyle(fontSize: 20),
      );
    else
      return Obx(
        () => (mode == Mode.pin && stage.value == 1)
            ? Text(
                "Enter your Current Pin to Continue",
                style: TextStyle(fontSize: 20),
              )
            : (stage.value == 1 || (mode == Mode.pin && stage.value == 2))
                ? Text("Enter your Password to Continue", style: TextStyle(fontSize: 20))
                : (mode == Mode.email)
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
      );
  }

  Widget getTextField() {
    if (mode == Mode.pin || mode == Mode.pinWithBiometrics) {
      return Obx(
        () => (stage.value == 2)
            ? PasswordTextField(
                controller: textController,
                key: ValueKey('passwordfield'),
                hintText: "",
              )
            : TextField(
                keyboardType: TextInputType.number,
                obscureText: true,
                controller: textController,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                decoration: textFieldDecoration,
              ),
      );
    } else if (mode == Mode.password) {
      return PasswordTextField(
        controller: textController,
        key: ValueKey('passwordfield'),
        hintText: "",
      );
    } else if (mode == Mode.name) {
      return TextField(
        controller: textController,
        style: TextStyle(fontSize: 20),
        decoration: textFieldDecoration,
      );
    } else {
      return Obx(
        () => stage.value == 1
            ? PasswordTextField(
                controller: textController,
                key: ValueKey('passwordfield'),
                hintText: "",
              )
            : TextField(
                keyboardType: TextInputType.emailAddress,
                controller: textController,
                style: TextStyle(fontSize: 20),
                decoration: textFieldDecoration,
              ),
      );
    }
  }

  Widget getButton(BuildContext context) {
    if (mode == Mode.name)
      return BottomSheetButton(
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
      );
    else if (mode == Mode.pinWithBiometrics) {
      return ContinueButton(onPressed: () {
        if (controller.isPinCorrect(int.tryParse(textController.text))) {
          Get.back<bool>(result: true);
        } else {
          textController.clear();
          error("Used Pin is Incorrect.");
        }
      });
    }
    return Obx(
      () => (mode == Mode.pin && stage.value == 1)
          ? ContinueButton(
              onPressed: () {
                if (controller.isPinCorrect(int.tryParse(textController.text))) {
                  error(null);
                  Get.offNamed(PinSetScreen.id);
                } else {
                  textController.clear();
                  error("Used Pin is Incorrect.");
                }
              },
            )
          : stage.value == 1 || (mode == Mode.pin && stage.value == 2)
              ? ContinueButton(
                  onPressed: () async {
                    try {
                      var credentials = EmailAuthProvider.credential(
                        email: controller.user!.email!,
                        password: textController.text,
                      );
                      await controller.user!.reauthenticateWithCredential(credentials);
                      textController.clear();
                      error(null);
                      if (stage.value != 1) {
                        Get.offNamed(PinSetScreen.id);
                      } else {
                        ++stage.value;
                      }
                    } catch (e) {
                      print(e);
                      error("${e.toString().split(']')[1]}");
                    }
                  },
                )
              : (mode == Mode.email)
                  ? BottomSheetButton(
                      onPressed: () async {
                        try {
                          if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                  caseSensitive: false)
                              .hasMatch(textController.text)) {
                            await controller.user!.updateEmail(textController.text);
                            error(null);
                            textController.clear();

                            Get.back();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Update Successful"),
                                backgroundColor: Colors.blue.shade900,
                              ),
                            );
                          } else {
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
                  : (stage.value == 2 && mode == Mode.password)
                      ? ContinueButton(onPressed: () {
                          password(textController.text);
                          error(null);
                          textController.clear();
                          ++stage.value;
                        })
                      : BottomSheetButton(
                          onPressed: () async {
                            try {
                              if (password.value == textController.text) {
                                await controller.user!.updatePassword(password.value);
                                textController.clear();
                                Get.back();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Update Successful"),
                                  backgroundColor: Colors.green,
                                ));
                              } else {
                                error("Passwords don't match. Please try again.");
                                textController.clear();
                              }
                            } catch (e) {
                              print(e);
                              error("${e.toString().split(']')[1]}");
                              textController.clear();
                            }
                          },
                          text: "Update Password",
                        ),
    );
  }
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
