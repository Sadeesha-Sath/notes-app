import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';

class NoteScreen extends StatelessWidget {
  static final String id = "/home/note";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey.shade800,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          AppbarButton(icon: Icons.edit, onTap: () {}),
          AppbarButton(icon: Icons.search_rounded, onTap: () {}),
          AppbarButton(icon: Icons.favorite_outline_rounded, onTap: () {}),
          AppbarButton(icon: Icons.more_vert_rounded, onTap: () {}),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Text("Hello, this is the title"),
            Text("Sat, 22 Jun 2020"),
            Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis condimentum purus sit amet arcu laoreet, a maximus est fringilla. Nam eget bibendum urna, in eleifend elit. Nulla porta blandit dui semper suscipit. Fusce mi neque, imperdiet eu nisl eget, vulputate commodo libero. Integer id tincidunt felis. Etiam imperdiet commodo lacus ut sagittis. Curabitur semper vestibulum hendrerit. In blandit tellus at nibh ornare congue. Quisque at imperdiet tortor."),
          ],
        ),
      ),
    );
  }
}
