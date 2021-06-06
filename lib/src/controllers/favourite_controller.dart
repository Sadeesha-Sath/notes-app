import 'package:get/get.dart';

class FavouritesController extends GetxController {
  RxSet<int> selectedItems = RxSet();

  bool getBool(int index) {
    if (selectedItems.contains(index)) return true;
    return false;
  }

  void toggleCheckbox(int index) {
    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
    } else {
      selectedItems.add(index);
    }
  }
}
