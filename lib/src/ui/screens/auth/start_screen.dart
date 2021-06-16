import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/screens/auth/login_screen.dart';
import 'package:notes_app/src/ui/screens/auth/register_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/auth/social_media_login_bottomsheet.dart';

class StartScreen extends StatelessWidget {
  static final id = "/start";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeAwareBackgroundColor(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 13 * Get.height / 14,
            padding: EdgeInsets.symmetric(horizontal: Get.size.width / 15, vertical: Get.size.height / 40),
            child: Column(
              children: [
                Spacer(),
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
                StartScreenButton(
                  onPressed: () {
                    Get.toNamed(RegisterScreen.id);
                  },
                  text: "I'm in",
                  backgroundColor: Colors.blue,
                ),
                StartScreenButton(
                  text: "Get Started With Social Accounts",
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                        builder: (context) => SocialMedialoginBottomSheet());
                  },
                  backgroundColor: Colors.black54,
                ),
                Spacer(),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Already a User?  "),
                      TextSpan(
                        text: " Sign In ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
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
      ),
    );
  }
}

// TODO Maybe use just the social icon as the  login button instead of a bottomsheet

class StartScreenButton extends StatelessWidget {
  StartScreenButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: ElevatedButton(
        style: ButtonStyle(
          foregroundColor: Get.isDarkMode ? MaterialStateProperty.all(kElevatedForegroundDark) : null,
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.5),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
