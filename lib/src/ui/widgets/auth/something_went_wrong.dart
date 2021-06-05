import 'package:flutter/material.dart';

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "OH NO!",
          style: TextStyle(color: Colors.black87, fontSize: 40),
        ),
        Text(
          "Looks like something went wrong. Please check your connection and try again.",
          style: TextStyle(color: Colors.grey.shade800, fontSize: 28),
        ),
      ],
    ));
  }
}
