import 'package:get/get.dart';

class LockedScreenController extends GetxController {
  RxSet<int> selectedItems = RxSet();
  RxBool selectMode = false.obs;

  bool getBool(int index) {
    if (selectedItems.contains(index)) return true;
    return false;
  }

  void toggleMode() {
    selectMode.toggle();
  }

  void toggleCheckbox(bool value, int index) {
    if (value) {
      selectedItems.add(index);
    } else {
      selectedItems.remove(index);
      if (selectedItems.isEmpty) {
        selectMode.value = false;
      }
    }
  }
}
