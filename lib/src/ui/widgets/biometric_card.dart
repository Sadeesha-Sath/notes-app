import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/screens/app/locked_notes_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class BiometricCard extends StatelessWidget {
  BiometricCard({
    Key? key,
    required this.error,
    this.usePin,
    this.autorizeOnly = true,
  }) : super(key: key);

  final _localAuth = LocalAuthentication();
  final Rx<String?> error;
  final RxBool? usePin;
  final bool autorizeOnly;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Color(0xFFA2D1F6),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          try {
            bool isAuthenticated = await _localAuth.authenticate(
              localizedReason: "Access your Vault",
              biometricOnly: true,
              stickyAuth: true,
            );
            if (isAuthenticated) {
              if (autorizeOnly) {
                Get.back<bool>(result: true);
              } else {
                Get.offNamed(LockedNotesScreen.id);
              }
            } else {
              error("Look like your biometrics don't match. Please use the pin to continue.");
              if (usePin != null) usePin!(true);
            }
          } catch (e) {
            print(e);
            error("Look like your biometrics don't work. Please use the pin to continue.");
            if (usePin != null) usePin!(true);
          }
        },
        child: Container(
          width: Get.width - 100,
          height: 160,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fingerprint_rounded,
                  size: 40,
                ),
                kSizedBox20,
                Text(
                  "Use Biometrics",
                  style: TextStyle(fontSize: 19),
                ),
              ],
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
