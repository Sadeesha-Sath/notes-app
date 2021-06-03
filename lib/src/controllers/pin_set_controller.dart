import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';

class PinSetController extends GetxController {
  TextEditingController pin1 = TextEditingController();
  TextEditingController pin2 = TextEditingController();
  var stage = 1.obs;
  var hidePin = true.obs;
  var invalidInput = false.obs;
  var errorMessage = "Invalid Input. Only Numbers are allowed. Please try again".obs;

  void isInt(String value) {
    if (int.tryParse(value) != null) {
      invalidInput.value = false;
      if (stage.value == 1) {
        ++stage;
      } else
        checkPin();
    } else {
      errorMessage.value = "Invalid Input. Only Numbers are allowed. Please try again.";
      invalidInput.value = true;
      stage.value == 1 ? pin1.clear() : pin2.clear();
    }
  }

  void pinVisibilityToggle() => hidePin.toggle();

  void checkPin() {
    print("checking pin");
    if (pin1.text == pin2.text) {
      Get.find<UserController>().setPin(int.tryParse(pin1.text)!);
      ++stage;
    } else {
      errorMessage.value = "Pins Don't match. Please check and try again.";
      invalidInput.value = true;
    }
  }
}
