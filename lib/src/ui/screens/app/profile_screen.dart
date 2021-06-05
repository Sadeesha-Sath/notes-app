import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/about_section.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/contents_section.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/preferences_section.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/profile_screen_listtile.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/section_separator.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/user_section.dart';

class ProfileScreen extends StatelessWidget {
  static final id = '/profile';

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
                UserSection(),
                SizedBox(height: 22),
                SectionSeparator("CONTENTS"),
                ContentsSection(),
                SizedBox(height: 15),
                SectionSeparator("PREFERENCES"),
                PreferencesSection(),
                SizedBox(height: 15),
                SectionSeparator("ABOUT"),
                AboutSection(),
                SizedBox(height: 15),
                SectionSeparator("ACCOUNT"),
                AccountSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountSection extends StatelessWidget {
  const AccountSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileScreenListTile(
          title: "Reset Password",
          icon: Icons.password_rounded,
          onTap: () {},
          // TODO Implement reset password
        ),
        ProfileScreenListTile(
          title: "Sign Out",
          icon: Icons.exit_to_app_rounded,
          onTap: () => Get.find<FirebaseAuthController>().signOutUser(),
          color: Colors.redAccent,
        ),
      ],
    );
  }
}
