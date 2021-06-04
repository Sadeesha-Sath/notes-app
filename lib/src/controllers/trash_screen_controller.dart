import 'package:get/get.dart';

class TrashScreenController extends GetxController {
  RxSet<int> selectedItems = RxSet();

  bool getBool(int index) {
    if (selectedItems.contains(index)) return true;
    return false;
  }

  void toggleCheckbox(bool value, int index) {
    if (value) {
      selectedItems.add(index);
    } else {
      selectedItems.remove(index);
    }
  }
}
