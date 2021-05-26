import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialMedialoginBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF4285F4)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.google),
                    Spacer(),
                    Text("Continue With Google", style: TextStyle(fontSize: 15)),
                    Spacer()
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black54),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.apple),
                    Spacer(),
                    Text(
                      "Continue With Apple",
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer()
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF3B5998)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.facebookF),
                    Spacer(),
                    Text(
                      "Continue With Facebook",
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
