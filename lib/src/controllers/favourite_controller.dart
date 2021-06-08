import 'package:get/get.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/models/note_model.dart';

class FavouritesController extends GetxController {
  RxList<NoteModel> favourites =
      RxList(Get.find<NotesController>().notes!.where((element) => element.isFavourite).toList());
  RxSet<int> selectedItems = RxSet();

  bool getBool(int index) {
    if (selectedItems.contains(index)) return true;
    return false;
  }

  void clearSelectedItems() {
    selectedItems({});
  }

  void toggleCheckbox(int index) {
    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
    } else {
      selectedItems.add(index);
    }
  }

  void addNote(NoteModel note, int index) {
    favourites.insert(index, note);
  }

  void removeNote(int index) {
    favourites.removeAt(index);
  }
}
