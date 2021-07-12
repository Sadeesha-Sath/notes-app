import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/helpers/color_converter.dart';
import 'package:notes_app/src/helpers/content_trimmer.dart';
import 'package:notes_app/src/models/note_model.dart';

class LockedNoteCard extends StatelessWidget {
  final NoteModel model;
  final bool isSelectMode;

  LockedNoteCard(this.model, {this.isSelectMode = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: size,
      // height: (size != null) ? size! + Get.width / 2 - Get.width / 3 : size,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.hardEdge,
        color: ColorConverter.convertColor(model.color),
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                margin: isSelectMode ? EdgeInsets.only(left: 25) : null,
                alignment: Alignment.topLeft,
                child: Text(
                  ContentTrimmer.trimmer(model.title) ?? ContentTrimmer.trimmer(model.body) ?? "[No Content]",
                  strutStyle: StrutStyle(fontSize: 22),
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111111),
                  ),
                ),
              ),
              Spacer(),
              Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  model.getDateCreated,
                  style: TextStyle(
                    fontSize: 17,
                    color: Get.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade800,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
