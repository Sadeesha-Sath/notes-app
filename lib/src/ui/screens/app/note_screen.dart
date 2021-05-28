import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';

class NoteScreen extends StatelessWidget {
  static final String id = "/home/note";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: Colors.white,
        actions: [
          AppbarButton(icon: Icons.edit, onTap: () {}),
          AppbarButton(icon: Icons.search_rounded, onTap: () {}),
          AppbarButton(icon: Icons.favorite_outline_rounded, onTap: () {}),
          // TODO Make this Add/Remove from archive depending on the original note being in the archive or not
          AppbarButton(
                      popupMenuButton: PopupMenuButton(
              onSelected: (value) {
                switch (value) {
                  case "Add to Archive":
                  // Add to Archive
                    break;
                  case "Send to Trash":
                  // Add to Trash
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {
                  {'text': 'Add to Archive', 'iconData': Icons.archive_rounded, "color": Colors.grey.shade800},
                  {'text': 'Send to Trash', 'iconData': Icons.delete_rounded, 'color': Colors.redAccent}
                }.map((Map<String, dynamic> choice) {
                  return PopupMenuItem<String>(
                    value: choice['text'],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          choice['iconData'],
                          color: choice['color'],
                        ),
                        Text(
                          choice['text'],
                          style: TextStyle(color: choice['color']),
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ),
          // AppbarButton(icon: Icons.more_vert_rounded, onTap: () {}),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width / 20, vertical: Get.height / 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text(
              "Hello, this is the title",
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              "Sat, 22 Jun 2020",
              style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis condimentum purus sit amet arcu laoreet, a maximus est fringilla. Nam eget bibendum urna, in eleifend elit. Nulla porta blandit dui semper suscipit. Fusce mi neque, imperdiet eu nisl eget, vulputate commodo libero. Integer id tincidunt felis. Etiam imperdiet commodo lacus ut sagittis. Curabitur semper vestibulum hendrerit. In blandit tellus at nibh ornare congue. Quisque at imperdiet tortor.",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade900),
              maxLines: null,
              strutStyle: StrutStyle(fontSize: 21.5),
            ),
          ],
        ),
      ),
    );
  }
}
