import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/methods/show_custom_bottom_sheet.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
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
                      onPressed: () async {
                        try {
                          controller.updateName(_textController.text);
                          Database.updateName(controller.user!.uid, _textController.text);
                          if (controller.user?.displayName != null) {
                            controller.user!.updateProfile(displayName: _textController.text);
                          }
                          Get.back();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Update Successful"),
                              // backgroundColor: Colors.amber.shade50,
                            ),
                          );
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Update Unsuccessful"),
                              // backgroundColor: Colors.amber.shade50,
                            ),
                          );
                        }
                      },
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
                    var _textController = TextEditingController(text: controller.user!.email);
                    showCustomModalBottomSheet(
                      context,
                      textController: _textController,
                      mode: "Email",
                      onPressed: () {
                        // TODO Change profile data in auth
                        // TODO Verify email when changing
                        controller.user!
                            .updateEmail("user@example.com")
                            .then((value) => print("done"), onError: (error) => print(error));
                      },
                    );
                  },
                ),
                ProfileScreenListTile(
                  title: "Reset Password",
                  icon: Icons.password_rounded,
                  onTap: () {},
                  // TODO Implement reset password
                ),
                SizedBox(height: 35),
                Obx(() => !controller.user!.emailVerified
                    ? Container(
                        height: 130,
                        width: double.infinity,
                        color: Colors.red.shade200,
                        child: Column(
                          children: [
                            Spacer(
                              flex: 3,
                            ),
                            Text(
                              "Your email is not verified yet.",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Spacer(
                              flex: 3,
                            ),
                            Text(
                              "You will not be able to use it to recover your forgotten passwords and pins. Please check your inbox and verify via the verification email.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            Spacer(
                              flex: 4,
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
