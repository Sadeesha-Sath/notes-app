import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/services/local_preferences.dart';
import 'package:notes_app/src/ui/screens/auth/login_screen.dart';
import 'package:notes_app/src/ui/screens/auth/register_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/themes.dart';

class StartScreen extends StatelessWidget {
  static final id = "/start";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeAwareBackgroundColor(),
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                height: 13 * Get.height / 14,
                padding: EdgeInsets.symmetric(
                      horizontal: Get.size.width / 15,
                    ) +
                    EdgeInsets.only(top: 3, bottom: Get.height / 40),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(right: 20),
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        shape: CircleBorder(),
                        child: IconButton(
                          icon: Icon(
                            Get.isDarkMode ? CupertinoIcons.moon_zzz : CupertinoIcons.sun_max,
                          ),
                          onPressed: () {
                            Get.changeTheme(Get.isDarkMode ? ThemeData.light() : darkTheme);
                            LocalPreferences.isDarkMode = !LocalPreferences.isDarkMode!;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    SvgPicture.asset(
                      'assets/start.svg',
                      height: 0.92 * Get.height / 3,
                      semanticsLabel: "start_image",
                      // color: Colors.grey,
                      // colorBlendMode: BlendMode.color,
                    ),
                    Spacer(),
                    Text(
                      "Take your notes with you.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      "A Platform-independent Note taking software. Access and manage your notes, regardless of the Platform, including the Web.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(
                      flex: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40) + EdgeInsets.only(bottom: 18),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: Get.isDarkMode ? MaterialStateProperty.all(kElevatedForegroundDark) : null,
                          backgroundColor: Get.isDarkMode ? MaterialStateProperty.all(kElevatedBackgroundDark) : null,
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        ),
                        onPressed: () {
                          Get.toNamed(RegisterScreen.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13.5),
                          child: Center(
                            child: Text(
                              "I'm in",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialSignInButton(
                            icon: FontAwesomeIcons.google,
                            onPressed: () async {
                              await Get.find<FirebaseAuthController>().googleSignIn();
                            }),
                        SocialSignInButton(
                            icon: FontAwesomeIcons.apple,
                            onPressed: () {
                              // Currently has an issue with Android Platform
                            }),
                      ],
                    ),
                    Spacer(),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "Already a User?  "),
                          TextSpan(
                            text: " Sign In ",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Get.isDarkMode ? Colors.tealAccent.shade400 : Colors.blue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(LoginScreen.id);
                              },
                          ),
                        ],
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        shape: CircleBorder(),
        color: Get.isDarkMode ? Color(0xFF383838) : kLightBackground,
        child: IconButton(
          icon: FaIcon(
            icon,
            color: themeAwareTextColor(),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
