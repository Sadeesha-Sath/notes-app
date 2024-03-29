import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/ui/screens/app/edit_profile_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class UserSection extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Get.width / 20),
      child: Column(
        children: [
          Obx(
            () => CircleAvatar(
              backgroundColor: Get.isDarkMode ? Colors.teal.shade700 : null,
              foregroundImage: Get.find<FirebaseAuthController>().userTokenChanges?.photoURL != null
                  ? NetworkImage(Get.find<FirebaseAuthController>().userTokenChanges!.photoURL!)
                  : null,
              radius: 36,
            ),
          ),
          kSizedBox5,
          Obx(
            () => Text(
              controller.userModel?.name ?? "[No Name]",
              style: TextStyle(fontSize: 27, color: themeAwareTextColor()),
            ),
          ),
          kSizedBox3,
          Obx(
            () => Text(
              controller.user?.email ?? "[No Email]",
              style: TextStyle(color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700, fontSize: 16),
            ),
          ),
          SizedBox(height: 9),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 115),
            child: Stack(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(1.5),
                    padding: MaterialStateProperty.all(EdgeInsets.all(8.5)),
                    
                  ),
                  onPressed: () {
                    Get.toNamed(EditProfileScreen.id);
                  },
                  child: Row(
                    children: [
                      Spacer(
                        // flex: MediaQuery.of(context).orientation == Orientation.portrait ? 7 : 1,
                        flex: 7,
                      ),
                      Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                      ),
                      Spacer(
                        // flex: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 1,
                        flex: 2,
                      )
                    ],
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: getVerified(),
                    child: Positioned(
                      right: 3,
                      top: 2,
                      child: Material(
                        shape: CircleBorder(),
                        color: Colors.redAccent,
                        elevation: 1,
                        child: Container(
                          width: 14,
                          height: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool getVerified() {
    if (controller.user == null) return true;
    return !Get.find<FirebaseAuthController>().userTokenChanges!.emailVerified;
  }
}
