import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/helpers/content_trimmer.dart';
import 'package:notes_app/src/models/note_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel model;
  final double? size;

  NoteCard(this.model, {this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: (size != null) ? size! + Get.width / 2 - Get.width / 3 : size,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.hardEdge,
        color: Colors.blue,
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  ContentTrimmer.trimmer(model.title, size != null ? 27 : null) ??
                      ContentTrimmer.trimmer(model.body, size != null ? 27 : null) ??
                      "[No Content]",
                  strutStyle: StrutStyle(fontSize: 22),
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                ),
              ),
              Spacer(),
              Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  model.getDateCreated,
                  style: TextStyle(fontSize: 17, color: Colors.grey.shade800),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
