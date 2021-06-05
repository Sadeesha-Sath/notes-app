import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreenListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData icon;
  final Color? color;

  ProfileScreenListTile({required this.title, required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Color(0xFF070707),
        ),
      ),
      leading: Icon(
        icon,
        color: color ?? Color(0xFF656565),
      ),
      trailing: color == null
          ? Icon(
              Icons.arrow_forward_ios_rounded,
              size: 22,
            )
          : null,
    );
  }
}
