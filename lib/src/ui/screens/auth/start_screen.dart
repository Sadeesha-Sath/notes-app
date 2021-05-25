import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/screens/auth/login_screen.dart';
import 'package:notes_app/src/ui/screens/auth/register_screen.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                  onPressed: () {
                    Get.toNamed(RegisterScreen.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13.0),
                    child: Center(
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF4285F4)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                    child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.google),
                        Spacer(),
                        Text("Continue With Google", style: TextStyle(fontSize: 15)),
                        Spacer()
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black54),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                    child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.apple),
                        Spacer(),
                        Text(
                          "Continue With Apple",
                          style: TextStyle(fontSize: 15),
                        ),
                        Spacer()
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF3B5998)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                    child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.facebookF),
                        Spacer(),
                        Text(
                          "Continue With Facebook",
                          style: TextStyle(fontSize: 15),
                        ),
                        Spacer()
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text("Already a User?"),
              //     TextButton(
              //         onPressed: () {
              //           Get.toNamed("login");
              //         },
              //         child: Text("Log In"))
              //   ],
              // ),
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
