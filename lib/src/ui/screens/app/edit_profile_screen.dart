import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';

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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: Get.height / 35),
            child: Column(
              children: [
                CircleAvatar(
                  foregroundImage: controller.userModel!.userData.profileUrl != null
                      ? NetworkImage(controller.userModel!.userData.profileUrl!)
                      : null,
                  radius: 100,
                ),
                SizedBox(height: 7.5),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Change Profile Picture",
                      style: TextStyle(fontSize: 17),
                    )),
                SizedBox(height: 7.5),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 30),
                  horizontalTitleGap: 16,
                  leading: Icon(Icons.person),
                  title: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(fontSize: 19),
                        ),
                        Text(
                          controller.userModel!.userData.name,
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => Container(
                              padding: EdgeInsets.all(25),
                              height: 250,
                              child: Column(
                                children: [
                                  Text(
                                    "Enter New Name",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextField(
                                    decoration: textFieldDecoration.copyWith(hintText: ""),
                                  ),
                                  SizedBox(
                                    height: 45,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Update Name",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(horizontal: 20, vertical: 12.5),
                                      ),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                    ),
                                  )
                                ],
                              ),
                            ));
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 30),
                  horizontalTitleGap: 16,
                  leading: Icon(Icons.email_rounded),
                  title: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(fontSize: 19),
                        ),
                        Text(
                          controller.userModel!.userData.email,
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => Container(
                              padding: EdgeInsets.all(25),
                              height: 250,
                              child: Column(
                                children: [
                                  Text(
                                    "Enter New Email",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextField(
                                    decoration: textFieldDecoration.copyWith(hintText: ""),
                                  ),
                                  SizedBox(
                                    height: 45,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Update Email",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(horizontal: 20, vertical: 12.5),
                                      ),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                    ),
                                  )
                                ],
                              ),
                            ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
