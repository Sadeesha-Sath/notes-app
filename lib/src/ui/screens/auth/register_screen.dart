import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/register_controller.dart';
import 'package:notes_app/src/ui/screens/app/home_screen.dart';
import 'package:notes_app/src/ui/screens/auth/login_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';

class RegisterScreen extends StatelessWidget {
  static final String id = "/register";
  final RegisterController _registerController = RegisterController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Get.size.width / 50, vertical: Get.size.height / 45),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: CustomBackButton()
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's sign you up.",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Welcome Onboard!",
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: TextField(
                  style: TextStyle(fontSize: 16),
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.left,
                  onChanged: (value) {
                    _registerController.email = value;
                    //Do something with the user input.
                  },
                  decoration: textFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.person),
                    hintText: "Enter your email",
                  ),
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: TextField(
                    obscureText: _registerController.hidePassword1.value,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      _registerController.password1 = value;
                      //Do something with the user input.
                    },
                    decoration: textFieldDecoration.copyWith(
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          print("Changing Visibility");
                          _registerController.toggleHidePassword1();
                        },
                        icon: Icon(_registerController.hidePassword1.value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded),
                      ),
                      hintText: "Enter a password",
                    ),
                  ),
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: TextField(
                    obscureText: _registerController.hidePassword2.value,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      _registerController.password2 = value;
                      //Do something with the user input.
                    },
                    decoration: textFieldDecoration.copyWith(
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          print("Changing Visibility");
                          _registerController.toggleHidePassword2();
                        },
                        icon: Icon(_registerController.hidePassword2.value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded),
                      ),
                      hintText: "Retype the password",
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                  onPressed: () {
                    Get.offAllNamed(HomeScreen.id);
                  },
                  child: Center(
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 17),
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
                          Get.offNamed(LoginScreen.id);
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
