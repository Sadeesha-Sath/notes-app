import 'package:flutter/material.dart';

class AppbarButton extends StatelessWidget {
  final IconData icon;
  final onTap;

  AppbarButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      width: 45,
      child: Material(
        color: Colors.grey.shade600,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}
