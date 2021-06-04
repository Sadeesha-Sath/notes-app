import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/helpers/content_trimmer.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/ui/widgets/app_bar_button.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';

class TrashScreen extends GetView<NotesController> {
  static final String id = "/profile/trash";

  @override
  Widget build(BuildContext context) {
    controller.bindTrash();
    var trashedNotes = controller.deletedNotes;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [Icon(Icons.delete_rounded), Text("Trash")],
        ),
        actions: [
          AppbarButton(
            icon: Icons.restore_page_rounded,
            onTap: () {},
          ),
          AppbarButton(
            customIcon: Icon(
              Icons.delete_forever_rounded,
              color: Colors.red.shade200,
            ),
            onTap: () {},
          ),
        ],
        leading: CustomBackButton(),
      ),
      body: trashedNotes != null && trashedNotes.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                //TODO Add some drag support
                NoteModel note = trashedNotes[index];
                return ListTile(
                  title: Text(
                    ContentTrimmer.trimTitle(note.title) ?? ContentTrimmer.trimBody(note.body) ?? "[No Contents]",
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_sharp),
                );
              },
              itemCount: trashedNotes.length,
            )
          : Container(),
          // TODO Make a view to accomadate empty trash
    );
  }
}
