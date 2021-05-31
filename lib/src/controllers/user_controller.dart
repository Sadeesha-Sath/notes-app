import 'package:get/get.dart';
import 'package:notes_app/src/models/user.dart';
import 'package:notes_app/src/services/database.dart';

class UserController extends GetxController {
  Rx<UserModel?> _userModel = Rx<UserModel?>(null);

  UserModel? get user => _userModel.value;

  set setUser(UserModel? value) {
    this._userModel.value = value;
    print(_userModel.value?.uid);
  }

  void clear() {
    _userModel.value = null;
  }

  bool isPinSet() {
    if (_userModel.value?.archivesPin == null) return false;
    return true;
  }

  bool isPinCorrect(int pin) {
    if (pin.hashCode == _userModel.value!.archivesPin) return true;
    return false;
  }

  bool resetPin(int pin) {
    if (isPinCorrect(pin)) {
      _userModel.update((val) {
        val!.archivesPin = pin.hashCode;
      });
      updatePin(pin);
      return true;
    }
    return false;
  }

  bool setPin(int pin) {
    if (_userModel.value!.archivesPin == null) {
      _userModel.update((val) {
        val!.archivesPin = pin.hashCode;
      });
      updatePin(pin);
      return true;
    }
    return false;
  }

  void updatePin(int pin) {
    Database().updatePin(uid: _userModel.value!.uid, newPin: pin);
  }
}
