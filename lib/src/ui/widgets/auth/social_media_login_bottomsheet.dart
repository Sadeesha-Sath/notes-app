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
          SocialMediaButton(
            text: "Google",
            icon: FontAwesomeIcons.google,
            color: Color(0xFF4285F4),
            onPressed: () {},
          ),
          SocialMediaButton(
            text: "Apple",
            icon: FontAwesomeIcons.apple,
            color: Colors.black54,
            onPressed: () {},
          ),
          SocialMediaButton(
            text: "Facebook",
            icon: FontAwesomeIcons.facebookF,
            color: Color(0xFF3B5998),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  SocialMediaButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.text,
    required this.color,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onPressed;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            children: [FaIcon(icon), Spacer(), Text("Continue With $text", style: TextStyle(fontSize: 15)), Spacer()],
          ),
        ),
      ),
    );
  }
}
