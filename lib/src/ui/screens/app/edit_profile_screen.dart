import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/methods/show_custom_bottom_sheet.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/profile_screen_listtile.dart';

class EditProfileScreen extends GetView<UserController> {
  const EditProfileScreen({Key? key}) : super(key: key);
  static final String id = "/profile/edit";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: Get.height / 25),
            child: Column(
              children: [
                CircleAvatar(
                  foregroundImage: controller.user?.photoURL != null ? NetworkImage(controller.user!.photoURL!) : null,
                  radius: 110,
                ),
                SizedBox(height: 10),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Change Profile Picture",
                      style: TextStyle(fontSize: 17),
                    )),
                SizedBox(height: 15),
                ProfileScreenListTile(
                  titleWidget: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(fontSize: 16, color: Color(0xFF070707)),
                        ),
                        Obx(
                          () => Text(
                            controller.userModel!.name,
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  icon: Icons.person,
                  onTap: () {
                    var _textController = TextEditingController(text: controller.userModel!.name);
                    showCustomModalBottomSheet(
                      context,
                      textController: _textController,
                      mode: "Name",
                    );
                  },
                ),
                ProfileScreenListTile(
                  titleWidget: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(fontSize: 16, color: Color(0xFF070707)),
                        ),
                        Obx(
                          () => Text(
                            controller.user!.email!,
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  icon: Icons.email,
                  onTap: () {
                    var _textController = TextEditingController();
                    showCustomModalBottomSheet(
                      context,
                      textController: _textController,
                      mode: "Email",
                    );
                  },
                ),
                ProfileScreenListTile(
                  title: "Reset Password",
                  icon: Icons.password_rounded,
                  onTap: () {
                    var _textController = TextEditingController();
                    showCustomModalBottomSheet(context, textController: _textController, mode: "password");
                  },
                  // TODO Implement reset password
                ),
                SizedBox(height: 35),
                Obx(() => !controller.user!.emailVerified
                    ? Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.red.shade200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(
                              flex: 7,
                            ),
                            Text(
                              "Your email is not verified yet.",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Spacer(
                              flex: 5,
                            ),
                            Text(
                              "You will not be able to use it to recover your forgotten passwords and pins. Please check your inbox and verify via the verification email.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            Spacer(flex: 1),
                            TextButton(
                                onPressed: () {
                                  controller.user!.sendEmailVerification();
                                },
                                child: Text(
                                  "Cannot find the email? Resend here.",
                                  style:
                                      TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.blue.shade800),
                                )),
                            Spacer(
                              flex: 2,
                            ),
                          ],
                        ),
                      )
                    : Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
