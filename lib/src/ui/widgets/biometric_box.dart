import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/services/local_preferences.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class BiometricBox extends StatefulWidget {
  BiometricBox({Key? key});

  @override
  _BiometricBoxState createState() => _BiometricBoxState();
}

class _BiometricBoxState extends State<BiometricBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: InkWell(
        onTap: () {
          setState(() {
            LocalPreferences.biometrics = !LocalPreferences.biometrics;
          });
        },
        child: Container(
          padding: EdgeInsets.only(
            top: 15,
          ),
          child: Column(
            children: [
              Icon(
                Icons.fingerprint_rounded,
                color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                size: 50,
              ),
              kSizedBox10,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Use Biometrics",
                    style: TextStyle(fontSize: 16),
                  ),
                  Switch.adaptive(
                      value: LocalPreferences.biometrics,
                      onChanged: (bool value) {
                        setState(() {
                          LocalPreferences.biometrics = value;
                        });
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
