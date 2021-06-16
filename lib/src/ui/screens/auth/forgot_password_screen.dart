import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/auth/email_text_field.dart';
import 'package:notes_app/src/ui/widgets/continue_button.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';

class ForgotPasswordScreen extends GetView<FirebaseAuthController> {
  static final String id = "/login/forgot_password";
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Rx<String?> error = Rx(null);
    RxBool showSpinner = false.obs;
    return Scaffold(
      backgroundColor: themeAwareBackgroundColor(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 13 * Get.height / 14,
            padding: EdgeInsets.symmetric(horizontal: Get.size.width / 50, vertical: Get.size.height / 45),
            child: Column(
              children: [
                Container(alignment: Alignment.topLeft, child: CustomBackButton()),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Forgot Your Password?",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      kSizedBox20,
                      Text(
                        "No Worries. Let's get Your Data to You...",
                        style: TextStyle(fontSize: 25),
                        strutStyle: StrutStyle(fontSize: 32),
                      ),
                    ],
                  ),
                ),
                Spacer(
                  flex: 5,
                ),
                EmailTextField(controller: _textEditingController),
                Spacer(),
                Obx(
                  () => Visibility(
                    visible: error.value != null,
                    child: Text(
                      error.value.toString().split("]").last,
                      style: TextStyle(color: Colors.redAccent, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Obx(() => Visibility(
                      child: CircularProgressIndicator.adaptive(),
                      visible: showSpinner.value,
                    )),
                Spacer(
                  flex: 10,
                ),
                ContinueButton(
                    paddingVal: 120,
                    onPressed: () async {
                      showSpinner(true);
                      var e = await controller.sendPasswordResetEmail(_textEditingController.text.trim());
                      if (e != null) {
                        showSpinner(false);
                        error(e.toString());
                        _textEditingController.clear();
                      } else {
                        showSpinner(false);
                        error.value = null;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "A Password reset request was sent to ${_textEditingController.text.trim()}. Please use it to reset your password.",
                              style: TextStyle(fontSize: 12),
                              strutStyle: StrutStyle(fontSize: 13),
                            ),
                          ),
                        );
                        _textEditingController.clear();
                        Get.back();
                      }
                    }),
                Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
