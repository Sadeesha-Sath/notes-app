import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/screens/auth/login_screen.dart';
import 'package:notes_app/src/ui/screens/auth/register_screen.dart';
import 'package:notes_app/src/ui/widgets/social_media_login_bottomsheet.dart';

class StartScreen extends StatelessWidget {
  static final id = "/start";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Get.size.width / 15, vertical: Get.size.height / 40),
          child: Column(
            children: [
              Spacer(),
              CircleAvatar(
                radius: 100,
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
                style: TextStyle(fontSize: 15),
              ),
              Spacer(
                flex: 3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                  onPressed: () {
                    Get.toNamed(RegisterScreen.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13.5),
                    child: Center(
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              // TODO Refractor
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black54),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                        builder: (context) => SocialMedialoginBottomSheet());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13.5),
                    child: Center(
                      child: Text(
                        "Get Started With Social Accounts",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "Already a User?  "),
                    TextSpan(
                      text: " Sign In ",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(LoginScreen.id);
                        },
                    ),
                  ],
                ),
                style: TextStyle(fontSize: 15.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
