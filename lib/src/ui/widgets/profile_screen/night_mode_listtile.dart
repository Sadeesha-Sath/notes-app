import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/services/local_preferences.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/themes.dart';

class NightModeListTile extends StatefulWidget {
  @override
  _NightModeListTileState createState() => _NightModeListTileState();
}

class _NightModeListTileState extends State<NightModeListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SwitchListTile.adaptive(
        value: LocalPreferences.isDarkMode!,
        contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
        onChanged: (bool value) {
          setState(() {
            LocalPreferences.isDarkMode = value;
          });
          // ? Not working in android arm64 builds 🤷‍♂️
          Get.changeTheme(value ? darkTheme : ThemeData.light());

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
