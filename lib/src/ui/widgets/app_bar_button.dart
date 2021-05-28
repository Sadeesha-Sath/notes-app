import 'package:flutter/material.dart';

class AppbarButton extends StatelessWidget {
  final IconData? icon;
  final onTap;
  final PopupMenuButton? popupMenuButton;

  AppbarButton({this.icon, this.onTap, this.popupMenuButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      width: 45,
      child: Material(
        //TODO Find a good Color
        color: Colors.grey.shade800,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: popupMenuButton ??
            InkWell(
              onTap: onTap,
              child: Center(
                child: Icon(icon),
              ),
            ),
      ),
    );
  }
}
