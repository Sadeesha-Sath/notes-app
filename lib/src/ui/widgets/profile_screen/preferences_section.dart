import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/biometric_list_tile.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/night_mode_listtile.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/profile_screen_listtile.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          NightModeListTile(),
          ProfileScreenListTile(
            title: "Change Protected Space Pin",
            icon: Icons.phonelink_lock_outlined,
            onTap: () {},
          ),
          BiometricListTile(
            key: ValueKey('biometrics'),
          ),
        ],
      ),
    );
  }
}
