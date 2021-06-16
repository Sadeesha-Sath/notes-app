import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class AppbarButton extends StatelessWidget {
  final IconData? icon;
  final Icon? customIcon;
  final VoidCallback? onTap;
  final PopupMenuButton? popupMenuButton;
  final bool keepSameColor;

  AppbarButton({this.icon, this.onTap, this.popupMenuButton, this.customIcon, this.keepSameColor = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      width: 45,
      child: Material(
        color: keepSameColor
            ? Colors.grey.shade800
            : Get.isDarkMode
                ? kAppBarButtonColorDark
                : Colors.grey.shade800,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: popupMenuButton ??
            InkWell(
              onTap: onTap,
              child: Center(
                child: customIcon ??
                    Icon(
                      icon,
                    ),
              ),
            ),
      ),
    );
  }
}
