import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/file_handlers/inherited_preferences.dart';
import 'package:notes_app/src/ui/screens/app/locked_notes_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/biometric_card.dart';
import 'package:notes_app/src/ui/widgets/locked_notes_init.dart';

class UnlockLockedNotesScreen extends StatelessWidget {
  static final String id = "/unlock_locked_notes";
  final arguments = Get.arguments;

  @override
  Widget build(BuildContext context) {
    // print(arguments);
    return Scaffold(
      backgroundColor: themeAwareBackgroundColor(),
      body: SafeArea(
        child:
            Get.find<UserController>().isPinSet() ? UnlockWithBiometricOrPin() : LockedNotesInit(noteModel: arguments),
      ),
    );
  }
}

class UnlockWithBiometricOrPin extends StatelessWidget {
  late final Future<bool> isBiometric;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var usePin = false.obs;
    Rx<String?> error = Rx(null);
    isBiometric = LocalAuthentication().canCheckBiometrics;

    return SingleChildScrollView(
      child: Container(
        height: 14 * Get.height / 15,
        padding: EdgeInsets.all(25),
        alignment: Alignment.center,
        child: FutureBuilder(
            future: isBiometric,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                bool isBioEnabled = snapshot.data as bool;
                if (isBioEnabled) {
                  isBioEnabled = InheritedPreferences.of(context)!.preferences['isBiometricEnabled'] ?? false;
                }
                if (isBioEnabled)
                  usePin(false);
                else
                  usePin(true);
                return Column(
                  children: [
                    Spacer(
                      flex: 2,
                    ),
                    SvgPicture.asset(
                      Get.isDarkMode ? 'assets/unlock_intro_dark.svg' : 'assets/unlock_intro.svg',
                      height: 0.9 * Get.height / 3,
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Text(
                      "Welcome to Your Private and Secure Space",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(
                      flex: 4,
                    ),
                    Obx(
                      () => (usePin.value)
                          ? TextField(
                              controller: textController,
                              autofocus: usePin.value,
                              style: TextStyle(fontSize: 20),
                              decoration: (Get.isDarkMode
                                  ? textFieldDecorationDark
                                  : textFieldDecorationLight).copyWith(
                                      hintText: "Enter Your Protected Space Pin", hintStyle: TextStyle(fontSize: 17)),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              onSubmitted: (text) {
                                final int? value = int.tryParse(text);
                                if (value != null && Get.find<UserController>().isPinCorrect(value)) {
                                  error(null);
                                  Get.offNamed(LockedNotesScreen.id);
                                } else {
                                  error("The pin doesn't seem to match. Please try again.");
                                }
                              },
                            )
                          : (isBioEnabled)
                              ? BiometricCard(error: error, usePin: usePin)
                              : Spacer(flex: 2),
                    ),
                    Obx(
                      () => Visibility(
                        visible: usePin.value,
                        child: Spacer(flex: 2),
                      ),
                    ),
                    Obx(() => Visibility(
                          visible: error.value != null,
                          child: Text(
                            error.value.toString(),
                            strutStyle: StrutStyle(fontSize: 20),
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.redAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    Obx(
                      () => error.value == null ? Spacer(flex: 3) : Spacer(flex: 5),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 18, vertical: 10)),
                        backgroundColor: Get.isDarkMode ? MaterialStateProperty.all(kElevatedBackgroundDark) : null,
                        foregroundColor: Get.isDarkMode ? MaterialStateProperty.all(kElevatedForegroundDark) : null,
                        shape:
                            MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      ),
                      onPressed: () {
                        if (!usePin.value)
                          usePin(true);
                        else {
                          final int? value = int.tryParse(textController.text);
                          if (value != null && Get.find<UserController>().isPinCorrect(value)) {
                            Get.offNamed(LockedNotesScreen.id);
                          } else {
                            error("The pin doesn't seem to match. Please try again.");
                          }
                        }
                      },
                      child: Obx(
                        () => Text(
                          usePin.value ? "Continue" : "Use Pin Instead",
                          style: TextStyle(fontSize: 19),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Oh no, Something has gone wrong. Please try again in a bit',
                    style: TextStyle(fontSize: 19),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            }),
      ),
    );
  }
}
