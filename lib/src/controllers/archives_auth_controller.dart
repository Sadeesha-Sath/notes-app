import 'package:get/get.dart';

class ArchivesAuthController extends GetxController {
  RxBool isBiometActive = false.obs;
  int? _archivePin;

  void toggleBiometricsActiveState([bool? value]) {
    if (value != null)
      isBiometActive.value = value;
    else
      isBiometActive.toggle();
  }

  bool isPinSet() {
    if (_archivePin == null) return false;
    return true;
  }

  bool isPinCorrect(int pin) {
    if (pin.hashCode == _archivePin) return true;
    return false;
  }

  bool resetPin(int pin) {
    if (isPinCorrect(pin)) {
      _archivePin = pin.hashCode;
      return true;
    }
    return false;
  }

  bool setPin(int pin) {
    if (_archivePin == null) {
      _archivePin = pin.hashCode;
      return true;
    }
    return false;
  }
}
