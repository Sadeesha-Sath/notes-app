import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/ui/platform_aware_widgets/platform_alert_dialog.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/profile_screen_listtile.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileScreenListTile(
          title: "Delete Account",
          icon: Icons.close_rounded,
          onTap: () async {
            var value = await PlatformAlertDialog(
              title: "Confirm Delete Account",
              cancelText: "Cancel",
              confirmText: "Delete Forever",
              content:
                  "Are you sure about deleting your account? All your data will be deleted and you won't be able to recover them.",
              confirmColor: Colors.redAccent,
            ).show(context);

            if (value) {
              var user = Get.find<UserController>().user!;
              try {
                user.delete();
              } on FirebaseAuthException {
                // TODO Implement re Auth
                // await user.reauthenticateWithCredential(credential);
              }
            }
          },
          color: Colors.redAccent,
        ),
        ProfileScreenListTile(
          title: "Sign Out",
          icon: Icons.exit_to_app_rounded,
          onTap: () async {
            var value = await PlatformAlertDialog(
              title: "Confirm Sign Out",
              cancelText: "Cancel",
              confirmText: "Sign out",
              content: "Are you sure about signing out from this device?",
              confirmColor: Colors.redAccent,
            ).show(context);

            if (value) {
              Get.find<FirebaseAuthController>().signOutUser();
            }
          },
          color: Colors.redAccent,
        ),
      ],
    );
  }
}
