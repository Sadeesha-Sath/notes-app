import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/services/local_preferences.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class NightModeListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SwitchListTile.adaptive(
        value: Get.isDarkMode,
        contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
        onChanged: (bool value) {
          LocalPreferences.isDarkMode = value;

          Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
        },
        secondary: Icon(
          CupertinoIcons.moon,
          color: Get.isDarkMode ? kProfileListTileIconColorDark : kProfileListTileIconColorLight,
        ),
        title: Text(
          "Night Mode",
          style: TextStyle(
            color: Get.isDarkMode ? kProfileListTileTextColorDark : kProfileListTileTextColorLight,
          ),
        ),
      ),
    );
  }
}
