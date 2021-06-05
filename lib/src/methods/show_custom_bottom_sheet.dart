import 'package:flutter/material.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

Future showCustomModalBottomSheet(BuildContext context,
    {required TextEditingController textController,
    required String mode,
 
    required VoidCallback onPressed,
 }) {
  return showModalBottomSheet(
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      // isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(25),
          // height: 250,
          child: Column(
            children: [
              Text(
                "Enter New $mode",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: textController,
                style: TextStyle(fontSize: 20),
                decoration: textFieldDecoration.copyWith(hintText: ""),
              ),
              SizedBox(
                height: 45,
              ),
              ElevatedButton(
                onPressed: onPressed,
                child: Text(
                  "Update $mode",
                  style: TextStyle(fontSize: 18),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 20, vertical: 12.5),
                  ),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                ),
              )
            ],
          ),
        );
      });
}
