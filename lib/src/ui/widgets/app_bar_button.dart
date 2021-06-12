import 'package:flutter/material.dart';

class AppbarButton extends StatelessWidget {
  final IconData? icon;
  final Icon? customIcon;
  final onTap;
  final PopupMenuButton? popupMenuButton;

  AppbarButton({this.icon, this.onTap, this.popupMenuButton, this.customIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      width: 45,
      child: Material(
        color: Colors.grey.shade800,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: popupMenuButton ??
            InkWell(
              onTap: onTap,
              child: Center(
                child: customIcon ?? Icon(icon),
              ),
            ),
      ),
    );
  }
}
