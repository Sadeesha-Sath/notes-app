import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/services/database.dart';

class NotesController extends GetxController {
  Rx<List<NoteModel>?> noteList = Rx<List<NoteModel>?>(null);
  Rx<List<NoteModel>?> archivedNoteList = Rx<List<NoteModel>?>(null);
  Rx<List<NoteModel>?> deletedNoteList = Rx<List<NoteModel>?>(null);

  List<NoteModel>? get notes => noteList.value;
  List<NoteModel>? get archivedNotes => archivedNoteList.value;
  List<NoteModel>? get deletedNotes => deletedNoteList.value;

  @override
  void onInit() {
    String uid = Get.find<UserController>().user!.uid;
    // if (uid == null) {
    //   print("user not found");
    //   uid = Get.find<FirebaseAuthController>().user.value!.uid;
    // }
    noteList.bindStream(Database().noteStream(uid: uid, collectionName: "notes"));
    super.onInit();
  }

  void bindArchives() {
    String uid = Get.find<UserController>().user!.uid;

    // if (uid == null) {
    //   print("User again not found");
    //   uid = Get.find<FirebaseAuthController>().user.value!.uid;
    // }

    archivedNoteList.bindStream(Database().noteStream(uid: uid, collectionName: "archives"));
  }

  void bindTrash() {
    String uid = Get.find<UserController>().user!.uid;
    deletedNoteList.bindStream(Database().noteStream(uid: uid, collectionName: "trash"));
  }

  // @override
  // void onClose() {
  //   noteList.close();
  //   deletedNoteList.close();
  //   archivedNoteList.close();
  //   super.onClose();
  // }
}
