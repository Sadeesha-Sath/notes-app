import 'package:flutter/material.dart';
import 'package:notes_app/src/file_handlers/inherited_preferences.dart';
import 'package:notes_app/src/file_handlers/preferences_handler.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class BiometricBox extends StatefulWidget {
  BiometricBox({Key? key});

  @override
  _BiometricBoxState createState() => _BiometricBoxState();
}

class _BiometricBoxState extends State<BiometricBox> {
  @override
  Widget build(BuildContext context) {
    var initialValue = InheritedPreferences.of(context)!.preferences;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: InkWell(
        onTap: () {
          setState(() {
            InheritedPreferences.of(context)!.preferences['isBiometricEnabled'] = !initialValue['isBiometricEnabled']!;
          });
          PreferencesHandler().updatePreferences(preferences: initialValue);
        },
        child: Container(
          padding: EdgeInsets.only(
            top: 15,
          ),
          child: Column(
            children: [
              Icon(
                Icons.fingerprint_rounded,
                color: Colors.grey.shade700,
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
                      value: initialValue['isBiometricEnabled']!,
                      onChanged: (bool value) {
                        setState(() {
                          InheritedPreferences.of(context)!.preferences['isBiometricEnabled'] = value;
                        });
                        PreferencesHandler().updatePreferences(preferences: initialValue);
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
