import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/file_handlers/inherited_preferences.dart';
import 'package:notes_app/src/file_handlers/preferences_handler.dart';


class NightModeListTile extends StatelessWidget {
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
