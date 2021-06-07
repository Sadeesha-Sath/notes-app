import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/src/ui/widgets/profile_screen/profile_screen_listtile.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ProfileScreenListTile(
            title: "About Us",
            icon: Icons.info_outline_rounded,
            onTap: () {
              showAboutDialog(context: context);
            },
          ),
          ProfileScreenListTile(
            title: "Rate Us",
            icon: Icons.star_outline_outlined,
            onTap: () {},
          ),
          ProfileScreenListTile(
            title: "View Licences",
            // icon: Icons.document_scanner_outlined,
            icon: CupertinoIcons.doc_text,
            onTap: () {
              showLicensePage(context: context);
            },
          ),
        ],
      ),
    );
  }
}
