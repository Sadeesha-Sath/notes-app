import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/file_handlers/inherited_preferences.dart';
import 'package:notes_app/src/file_handlers/preferences_handler.dart';
import 'package:notes_app/src/ui/screens/app/edit_profile_screen.dart';
import 'package:notes_app/src/ui/screens/app/trash_screen.dart';
import 'package:notes_app/src/ui/screens/app/unlock_locked_notes_screen.dart';
import 'package:notes_app/src/ui/widgets/biometric_list_tile.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';

class ProfileScreen extends GetView<UserController> {
  static final id = '/profile';
  // final FirebaseAuthController _authController = Get.put(FirebaseAuthController());
  final FirebaseAuthController _authController = Get.find<FirebaseAuthController>();
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
                  child: CustomBackButton(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Get.width / 20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        foregroundImage: controller.userModel!.userData.profileUrl != null
                            ? NetworkImage(controller.userModel!.userData.profileUrl!)
                            : null,
                        radius: 36,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        controller.userModel!.userData.name,
                        style: TextStyle(fontSize: 27),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        controller.userModel!.userData.email,
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
                ),
                SizedBox(height: 22),
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
                            Icons.favorite_rounded,
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
                          onTap: () => Get.toNamed(UnlockLockedNotesScreen.id),
                          title: Text(
                            "Protected Space",
                            style: TextStyle(
                              color: Color(0xFF070707),
                            ),
                          ),
                          leading: Icon(
                            CupertinoIcons.lock_fill,
                            color: Color(0xFF656565),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 22,
                          ),
                        ),
                      ),
                      Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
                          onTap: () {
                            Get.toNamed(TrashScreen.id);
                          },
                          title: Text(
                            "Trash",
                            style: TextStyle(
                              color: Color(0xFF070707),
                            ),
                          ),
                          leading: Icon(
                            Icons.delete_rounded,
                            color: Color(0xFF656565),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
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
                      NightModeListTile(),
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
                            "Change Protected-Space Pin",
                            style: TextStyle(
                              color: Color(0xFF070707),
                            ),
                          ),
                        ),
                      ),
                      BiometricListTile(
                        key: ValueKey('biometrics'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
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
                          onTap: () {
                            showLicensePage(context: context);
                          },
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
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: Get.width / 22),
                  color: Color(0xFFF6F6F6),
                  width: double.infinity,
                  child: Text(
                    "ACCOUNT",
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
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
                    onTap: () {
                      // Sign Out
                      _authController.signOutUser();
                    },
                    leading: Icon(
                      Icons.exit_to_app_rounded,
                      color: Colors.redAccent,
                    ),
                    title: Text(
                      "Sign Out",
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NightModeListTile extends StatefulWidget {
  const NightModeListTile({
    Key? key,
  }) : super(key: key);

  @override
  _NightModeListTileState createState() => _NightModeListTileState();
}

class _NightModeListTileState extends State<NightModeListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SwitchListTile.adaptive(
        value: Get.isDarkMode,
        contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
        onChanged: (bool value) {
          InheritedPreferences.of(context)!.preferences['isNightMode'] = value;
          Get.changeTheme(value ? ThemeData.dark() : ThemeData.light());
          PreferencesHandler().updatePreferences(preferences: InheritedPreferences.of(context)!.preferences);
        },
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
    );
  }
}

// TODO Save nightMode and BiometricEnabling preference into the local storage
