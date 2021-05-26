
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/archives_auth_controller.dart';

class PinSetController extends GetxController {
  String pin1 = "";
  String pin2 = "";
  var hidePin = true.obs;
  bool invalidInput = false;
  String errorMessage = "Invalid Input. Only Numbers are allowed. Please try again";

  void isInt(String value) {
    if (int.tryParse(value) != null) {
      invalidInput = false;
    } else {
      errorMessage = "Invalid Input. Only Numbers are allowed. Please try again";
      invalidInput = true;
    }
    update();
  }

  void pinVisibilityToggle() => hidePin.toggle();

  void checkPin() {
    if (pin1 == pin2) {
      Get.find<ArchivesAuthController>().setPin(int.tryParse(pin1)!);
    } else {
      errorMessage = "Pins Don't match. Please check and try again.";
      invalidInput = true;
      update();
    }
  }
}
