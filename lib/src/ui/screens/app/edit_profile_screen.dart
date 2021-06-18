import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/ui/widgets/show_custom_bottom_sheet.dart';
import 'package:notes_app/src/models/mode_enum.dart';
import 'package:notes_app/src/services/storage.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/profile_screen_listtile.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends GetView<UserController> {
  EditProfileScreen({Key? key}) : super(key: key);
  static final String id = "/profile/edit";
  final RxBool showIndicator = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeAwareBackgroundColor(),
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: themeAwareBackgroundColor(),
        title: Text(
          "Edit Profile",
          style: TextStyle(color: themeAwareTextColor()),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: Get.height / 25, bottom: Get.height / 55),
            child: Column(
              children: [
                Obx(
                  () => CircleAvatar(
                    foregroundImage: Get.find<FirebaseAuthController>().userTokenChanges?.photoURL != null
                        ? NetworkImage(Get.find<FirebaseAuthController>().userTokenChanges!.photoURL!)
                        : null,
                    radius: 110,
                  ),
                ),
                kSizedBox10,
                TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        context: context,
                        builder: (context) => BottomSheet(),
                      );
                    },
                    child: Text(
                      "Change Profile Picture",
                      style: TextStyle(fontSize: 17, color: Get.isDarkMode ? kTextButtonColorDark : null),
                    )),
                kSizedBox15,
                ProfileScreenListTile(
                  titleWidget: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runAlignment: WrapAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Name:  ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Get.isDarkMode ? kProfileListTileTextColorDark : kProfileListTileTextColorLight),
                        ),
                        Obx(
                          () => Text(
                            controller.userModel!.name,
                            style: TextStyle(
                                fontSize: 16, color: Get.isDarkMode ? Color(0xFFA2A2A2) : Colors.grey.shade700),
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
                      mode: Mode.name,
                    );
                  },
                ),
                ProfileScreenListTile(
                  titleWidget: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runAlignment: WrapAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Email:  ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Get.isDarkMode ? kProfileListTileTextColorDark : kProfileListTileTextColorLight),
                        ),
                        Obx(
                          () => Text(
                            Get.find<FirebaseAuthController>().userTokenChanges!.email ?? "[No Email]",
                            style: TextStyle(
                                fontSize: 16, color: Get.isDarkMode ? Color(0xFFA2A2A2) : Colors.grey.shade700),
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
                      mode: Mode.email,
                    );
                  },
                ),
                ProfileScreenListTile(
                  title: "Reset Password",
                  icon: Icons.password_rounded,
                  onTap: () {
                    var _textController = TextEditingController();
                    showCustomModalBottomSheet(context, textController: _textController, mode: Mode.password);
                  },
                ),
                kSizedBox35,
                Obx(
                  () => Visibility(
                    visible: getVerified(),
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          color: Get.isDarkMode ? Color(0xFF975353) : Color(0xFFEFBABA),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(
                                flex: 9,
                              ),
                              Text(
                                "Your email is not verified yet.",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              Spacer(
                                flex: 6,
                              ),
                              Text(
                                "You will not be able to use it to recover your forgotten passwords and pins. Please check your inbox and verify via the verification email.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    controller.user!.sendEmailVerification();
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "A verification email was sent to ${Get.find<FirebaseAuthController>().userTokenChanges!.email}"),
                                      ),
                                    );
                                  } catch (e) {
                                    print(e);
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Verification email sending was unsuccessful."),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  "Cannot find the email? Resend here.",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Get.isDarkMode ? Colors.tealAccent : Colors.blue.shade800),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Container(
                          child: TextButton(
                            child: Text(
                              "Already Verified?",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Get.isDarkMode ? Colors.tealAccent.shade400 : null),
                            ),
                            onPressed: () async {
                              showIndicator(true);
                              await controller.user!.reload();
                              showIndicator(false);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    child: LinearProgressIndicator(),
                    visible: showIndicator.value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool getVerified() {
    if (controller.user == null) return true;
    return !Get.find<FirebaseAuthController>().userTokenChanges!.emailVerified;
  }
}

class BottomSheet extends StatelessWidget {
  BottomSheet({
    Key? key,
  }) : super(key: key);

  final _picker = ImagePicker();
  final _showLoading = RxBool(false);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose a Source",
            style: TextStyle(fontSize: 30),
          ),
          kSizedBox40,
          Container(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Container(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (await Permission.photos.isDenied) {
                            await Permission.photos.request();
                          }
                          if (await Permission.photos.isGranted || await Permission.photos.isLimited) {
                            try {
                              var pickedFile = await _picker.getImage(source: ImageSource.gallery);
                              print(pickedFile);
                              if (pickedFile != null) {
                                _showLoading(true);
                                await Storage.addProfileImage(File(pickedFile.path));
                                _showLoading(false);
                                Get.back();
                              }
                            } catch (e) {
                              print("this is an error     $e");
                            }
                          }
                        },
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.lightBlue),
                          child: Center(
                            child: Icon(
                              Platform.isIOS
                                  ? CupertinoIcons.photo_fill_on_rectangle_fill
                                  : Icons.photo_library_rounded,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                      kSizedBox15,
                      Text(
                        "Gallery",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                kSizedBox25,
                Container(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (await Permission.camera.isDenied) {
                            await Permission.camera.request();
                          }
                          if (await Permission.camera.isGranted || await Permission.camera.isLimited) {
                            try {
                              var pickedFile = await _picker.getImage(
                                  source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
                              if (pickedFile != null) {
                                _showLoading(true);
                                await Storage.addProfileImage(File(pickedFile.path));
                                _showLoading(false);
                                Get.back();
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.lightBlue),
                          child: Center(
                            child: Icon(
                              Platform.isIOS ? CupertinoIcons.photo_camera_solid : Icons.photo_camera,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                      kSizedBox15,
                      Text(
                        "Camera",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Obx(
            () => Visibility(
              visible: _showLoading.value,
              child: Container(
                child: Center(
                  child: LinearProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
