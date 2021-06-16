import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class ProfileScreenListTile extends StatelessWidget {
  final VoidCallback onTap;
  final Widget? titleWidget;
  final String? title;
  final IconData icon;
  final Color? color;

  ProfileScreenListTile({this.title, required this.icon, required this.onTap, this.color, this.titleWidget});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
      onTap: onTap,
      title: titleWidget ??
          Text(
            title!,
            style: TextStyle(
              color: color ?? (Get.isDarkMode ? kProfileListTileTextColorDark : kProfileListTileTextColorLight),
            ),
          ),
      leading: Icon(
        icon,
        color: color ?? (Get.isDarkMode ? kProfileListTileIconColorDark : kProfileListTileIconColorLight),
      ),
      trailing: color == null
          ? Icon(
              Icons.arrow_forward_ios_rounded,
              size: 22,
              color: Get.isDarkMode ? kProfileListTileTextColorDark : kProfileListTileTextColorLight,
            )
          : null,
    );
  }
}
