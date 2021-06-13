import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/about_section.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/account_section.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/contents_section.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/preferences_section.dart';
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
                kSizedBox15,
                SectionSeparator("PREFERENCES"),
                PreferencesSection(),
                kSizedBox15,
                SectionSeparator("ABOUT"),
                AboutSection(),
                kSizedBox15,
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
