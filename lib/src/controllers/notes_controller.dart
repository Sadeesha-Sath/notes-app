import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/services/database.dart';

class NotesController extends GetxController {
  Rx<List<NoteModel>?> noteList = Rx<List<NoteModel>?>(null);
  Rx<List<NoteModel>?> lockedNoteList = Rx<List<NoteModel>?>(null);
  Rx<List<NoteModel>?> deletedNoteList = Rx<List<NoteModel>?>(null);
  // Rx<List<NoteModel>?> favouritesList = Rx<List<NoteModel>?>(null);

  List<NoteModel>? get notes => noteList.value;
  List<NoteModel>? get lockedNotes => lockedNoteList.value;
  List<NoteModel>? get deletedNotes => deletedNoteList.value;
  // List<NoteModel>? get favourites => favouritesList.value;

  @override
  void onInit() {
    String uid = Get.find<UserController>().user!.uid;
    noteList.bindStream(Database.noteStream(uid: uid, collectionName: "notes"));
    super.onInit();
  }

  void bindLocked() {
    String uid = Get.find<UserController>().user!.uid;
    lockedNoteList.bindStream(Database.noteStream(uid: uid, collectionName: "locked"));
  }

  void bindTrash() {
    String uid = Get.find<UserController>().user!.uid;
    deletedNoteList.bindStream(Database.noteStream(uid: uid, collectionName: "trash"));
  }

  @override
  void onClose() {
    try {
      noteList.close();
      deletedNoteList.close();
      lockedNoteList.close();
    } catch (e) {
      print(e);
    }
    super.onClose();
  }
}
