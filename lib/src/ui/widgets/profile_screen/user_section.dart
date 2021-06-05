import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/ui/screens/app/edit_profile_screen.dart';

class UserSection extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Get.width / 20),
      child: Column(
        children: [
          CircleAvatar(
            foregroundImage: controller.userModel!.userData.profileUrl != null
                ? NetworkImage(controller.userModel!.userData.profileUrl!)
                : null,
            radius: 36,
          ),
          SizedBox(height: 5),
          Text(
            controller.userModel!.userData.name,
            style: TextStyle(fontSize: 27),
          ),
          SizedBox(height: 3),
          Text(
            controller.userModel!.userData.email,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
          ),
          SizedBox(height: 9),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 115),
            child: ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(8.5)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              onPressed: () {
                Get.toNamed(EditProfileScreen.id);
              },
              child: Row(
                children: [
                  Spacer(
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
                    flex: 2,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
