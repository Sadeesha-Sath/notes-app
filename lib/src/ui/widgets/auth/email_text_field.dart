import 'package:flutter/material.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({Key? key, required TextEditingController controller, this.autofocus = false})
      : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: TextField(
        autofocus: autofocus,
        style: TextStyle(fontSize: 16),
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.left,
        controller: _controller,
        decoration: textFieldDecoration.copyWith(
          prefixIcon: Icon(Icons.email),
          hintText: "Enter your email",
        ),
      ),
    );
  }
}
