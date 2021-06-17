import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes_app/src/services/local_preferences.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class BiometricListTile extends StatefulWidget {
  const BiometricListTile({
    Key? key,
  });

  @override
  _BiometricListTileState createState() => _BiometricListTileState();
}

class _BiometricListTileState extends State<BiometricListTile> {
  var _canCheckBio = LocalAuthentication().canCheckBiometrics;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _canCheckBio,
        builder: (context, snapshot) {
          return Visibility(
            visible: snapshot.connectionState == ConnectionState.done ? snapshot.data as bool : true,
            child: SwitchListTile.adaptive(
              value: LocalPreferences.biometrics,
              contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 11),
              onChanged: (bool value) {
                setState(() {
                  LocalPreferences.biometrics = value;
                });
              },
              secondary: Icon(
                Icons.fingerprint_rounded,
                color: Get.isDarkMode ? kProfileListTileIconColorDark : kProfileListTileIconColorLight,
              ),
              title: Text(
                "Use Biometric Authentication for Protected-Space",
                style: TextStyle(
                  color: Get.isDarkMode ? kProfileListTileTextColorDark : kProfileListTileTextColorLight,
                ),
              ),
            ),
          );
        });
  }
}
