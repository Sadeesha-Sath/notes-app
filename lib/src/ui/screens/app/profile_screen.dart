import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/archives_auth_controller.dart';

class ProfileScreen extends GetView<ArchivesAuthController> {
  static final id = '/profile';
  // final ArchivesAuthController _archivesAuthController = Get.find<ArchivesAuthController>();
  // TODO Refractor this
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: Get.height / 40),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Get.back(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Get.width / 20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "John Doe",
                        style: TextStyle(fontSize: 27),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "JohnDoe@abc.com",
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                      ),
                      SizedBox(
                        height: 9,
                      ),
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
                          onPressed: () {},
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
                ),
                SizedBox(
                  height: 22,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: Get.width / 22),
                  color: Color(0xFFF6F6F6),
                  width: double.infinity,
                  child: Text(
                    "CONTENTS",
                    style: TextStyle(
                        color: Color(0xFF9A9A9A), fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.2),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
                          onTap: () {},
                          leading: Icon(
                            Icons.favorite_outline_rounded,
                            color: Color(0xFF656565),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 22,
                          ),
                          title: Text(
                            "Favorites",
                            style: TextStyle(
                              color: Color(0xFF070707),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
                          onTap: () {},
                          title: Text(
                            "Archives",
                            style: TextStyle(
                              color: Color(0xFF070707),
                            ),
                          ),
                          leading: Icon(Icons.archive_rounded),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 22,
                          ),
                        ),
                      ),
                      Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
                          onTap: () {},
                          title: Text(
                            "Trash",
                            style: TextStyle(
                              color: Color(0xFF070707),
                            ),
                          ),
                          leading: Icon(Icons.delete_rounded),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: Get.width / 22),
                  color: Color(0xFFF6F6F6),
                  width: double.infinity,
                  child: Text(
                    "PREFERENCES",
                    style: TextStyle(
                      color: Color(0xFF9A9A9A),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.3,
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: SwitchListTile.adaptive(
                          value: Get.isDarkMode,
                          contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
                          onChanged: (bool value) => Get.changeTheme(value ? ThemeData.dark() : ThemeData.light()),
                          secondary: Icon(
                            CupertinoIcons.moon_fill,
                            color: Color(0xFF656565),
                          ),
                          title: Text(
                            "Night Mode",
                            style: TextStyle(
                              color: Color(0xFF070707),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
                          onTap: () {},
                          leading: Icon(
                            Icons.phonelink_lock_rounded,
                            color: Color(0xFF656565),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 22,
                          ),
                          title: Text(
                            "Change Archives Pin",
                            style: TextStyle(
                              color: Color(0xFF070707),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Obx(
                          () => SwitchListTile.adaptive(
                            value: controller.isBiometActive.value,
                            contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
                            onChanged: (bool value) => controller.toggleBiometricsActiveState(value),
                            secondary: Icon(
                              Icons.fingerprint_rounded,
                              color: Color(0xFF656565),
                            ),
                            title: Text(
                              "Use Biometric Authentication for Archives",
                              style: TextStyle(
                                color: Color(0xFF070707),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: Get.width / 22),
                  color: Color(0xFFF6F6F6),
                  width: double.infinity,
                  child: Text(
                    "ABOUT",
                    style: TextStyle(
                      color: Color(0xFF9A9A9A),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.3,
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
                          onTap: () {
                            // TODO Make this a bottom Sheet
                            showAboutDialog(context: context);
                          },
                          leading: Icon(
                            Icons.info_outline_rounded,
                            color: Color(0xFF656565),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 22,
                          ),
                          title: Text(
                            "About Us",
                            style: TextStyle(
                              color: Color(0xFF070707),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
                          onTap: () {},
                          leading: Icon(
                            Icons.star,
                            color: Color(0xFF656565),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 22,
                          ),
                          title: Text(
                            "Rate Us",
                            style: TextStyle(
                              color: Color(0xFF070707),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
                          onTap: () {},
                          leading: Icon(
                            Icons.document_scanner_rounded,
                            color: Color(0xFF656565),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 22,
                          ),
                          title: Text(
                            "View Licenses",
                            style: TextStyle(
                              color: Color(0xFF070707),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
