import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/file_handlers/inherited_preferences.dart';
import 'package:notes_app/src/file_handlers/preferences_handler.dart';


class BiometricListTile extends StatefulWidget {
  const BiometricListTile({
    Key? key,
  });

  @override
  _BiometricListTileState createState() => _BiometricListTileState();
}



class _BiometricListTileState extends State<BiometricListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SwitchListTile.adaptive(
        value: InheritedPreferences.of(context)!.preferences['isBiometricEnabled']!,
        contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
        onChanged: (bool value) {
          setState(() {
            InheritedPreferences.of(context)!.preferences['isBiometricEnabled'] = value;
          });
          PreferencesHandler().updatePreferences(preferences: InheritedPreferences.of(context)!.preferences);
        },
        secondary: Icon(
          Icons.fingerprint_rounded,
          color: Color(0xFF656565),
        ),
        title: Text(
          "Use Biometric Authentication for Archives",
          style: TextStyle(
            color: Color(0xFF070707),
          ),
        ),
      ),
    );
  }
}