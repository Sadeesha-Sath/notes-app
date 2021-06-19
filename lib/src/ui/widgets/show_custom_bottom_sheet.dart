import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/models/mode_enum.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/services/local_preferences.dart';
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
    return SingleChildScrollView(
      child: Container(
        height: 3 * Get.height / 5,
        padding: EdgeInsets.all(25),
        // height: 250,
        child: Column(
          children: [
            getTitle(),
            kSizedBox30,
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
            kSizedBox25,
            Visibility(
                visible: mode == Mode.pinWithBiometrics && LocalPreferences.biometrics,
                child: BiometricCard(error: error)),
            kSizedBox20,
            getButton(context),
            kSizedBox12,
            if (mode == Mode.password || mode == Mode.pin)
              Obx(
                () => Visibility(
                  visible: (mode == Mode.pin && stage.value == 2) || (mode == Mode.password && stage.value == 1),
                  child: TextButton(
                    onPressed: () async {
                      if (Get.find<UserController>().user!.emailVerified) {
                        var email = Get.find<UserController>().user!.email!;
                        Get.find<FirebaseAuthController>().sendPasswordResetEmail(email);
                        Get.back();
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("A password reset request was sent to $email"),
                          ),
                        );
                      } else {
                        Get.back();
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Your email isn't verified yet. Please verifiy your email to continue."),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(fontSize: 16.5, color: Get.isDarkMode ? Colors.tealAccent.shade400 : null),
                    ),
                  ),
                ),
              ),
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
                      style: TextStyle(fontSize: 16.5, color: Get.isDarkMode ? Colors.tealAccent.shade400 : null),
                    ),
                  ),
                ),
              ),
          ],
        ),
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
                key: ValueKey('passwordfield1'),
                hintText: "",
              )
            : TextField(
                keyboardType: TextInputType.number,
                obscureText: true,
                controller: textController,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                decoration: Get.isDarkMode ? textFieldDecorationDark : textFieldDecorationLight,
              ),
      );
    } else if (mode == Mode.password) {
      return PasswordTextField(
        controller: textController,
        key: ValueKey('passwordfield2'),
        hintText: "",
      );
    } else if (mode == Mode.name) {
      return TextField(
        controller: textController,
        style: TextStyle(fontSize: 20),
        decoration: Get.isDarkMode ? textFieldDecorationDark : textFieldDecorationLight,
      );
    } else {
      return Obx(
        () => stage.value == 1
            ? PasswordTextField(
                controller: textController,
                key: ValueKey('passwordfield3'),
                hintText: "",
              )
            : TextField(
                keyboardType: TextInputType.emailAddress,
                controller: textController,
                style: TextStyle(fontSize: 20),
                decoration: Get.isDarkMode ? textFieldDecorationDark : textFieldDecorationLight,
              ),
      );
    }
  }

  Widget getButton(BuildContext context) {
    if (mode == Mode.name)
      return BottomSheetButton(
        onPressed: () async {
          try {
            var text = textController.text;
            if (text == "") text = "[No Name]";
            controller.updateName(text);
            Database.updateName(controller.user!.uid, text);
            if (controller.user?.displayName != null) {
              controller.user!.updateDisplayName(text);
            }
            Get.back();
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Update Successful"),
                backgroundColor: Colors.blue.shade900,
              ),
            );
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).clearSnackBars();
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
        try {
          if (controller.isPinCorrect(int.parse(textController.text))) {
            Get.back<bool>(result: true);
          } else {
            textController.clear();
            error("Used Pin is Incorrect.");
          }
        } catch (e) {
          textController.clear();
          error("Used Pin is Incorrect.");
        }
      });
    }
    return Obx(
      () => (mode == Mode.pin && stage.value == 1)
          ? ContinueButton(
              onPressed: () {
                try {
                  if (controller.isPinCorrect(int.parse(textController.text))) {
                    error(null);
                    Get.offNamed(PinSetScreen.id);
                  } else {
                    textController.clear();
                    error("Used Pin is Incorrect.");
                  }
                } catch (e) {
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
                            ScaffoldMessenger.of(context).clearSnackBars();
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
                          Get.back();
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            "Update was Unsuccessful",
                            style: TextStyle(color: Get.isDarkMode ? kRedColorDark : Colors.redAccent),
                          ),),);
                        }
                      },
                      text: "Update Email",
                    )
                  : (stage.value == 2 && mode == Mode.password)
                      ? ContinueButton(
                          onPressed: () {
                            // Go to the second password
                            if (textController.text != "") {
                              password(textController.text);
                              error(null);
                              textController.clear();
                              ++stage.value;
                            } else {
                              error("Use a valid password");
                            }
                          },
                        )
                      : BottomSheetButton(
                          onPressed: () async {
                            try {
                              if (password.value == textController.text) {
                                await controller.user!.updatePassword(password.value);
                                textController.clear();
                                Get.back();
                                ScaffoldMessenger.of(context).clearSnackBars();
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
        backgroundColor: MaterialStateProperty.all(color ?? (Get.isDarkMode ? kElevatedBackgroundDark : null)),
        foregroundColor: color == null
            ? Get.isDarkMode
                ? MaterialStateProperty.all(kElevatedForegroundDark)
                : null
            : null,
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: 20, vertical: 12.5),
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }
}
