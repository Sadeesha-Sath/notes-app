import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/models/user.dart';
import 'package:notes_app/src/models/user_data.dart';
import 'package:notes_app/src/services/database.dart';

class UserController extends GetxController {
  Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  Rx<User?> _currentUser = Rx(Get.find<FirebaseAuthController>().user.value);

  User? get user => _currentUser.value;
  UserModel? get userModel => _userModel.value;

  @override
  onInit() async {
    _currentUser.bindStream(Get.find<FirebaseAuthController>().user.stream);
    if (user != null) {
      this._userModel.value = await Database().getUser(user!.uid);
    }
    ever(_currentUser, setUser);

    super.onInit();
  }

  void setUser(User? user) async {
    if (user != null) {
      try {
        print("getting user data from database");
        this._userModel.value = await Database().getUser(user.uid);
        print("getting user data successful");
      } catch (e) {
        print('error catched 1');
        print(e);
        UserModel _user = UserModel(
          userData: UserData(
            email: user.email!.trim(),
            name: user.email!.trim().split("@")[0],
          ),
          uid: user.uid,
        );
        print("created model");
        try {
          print('creating a new user');
          await Database().createNewUser(_user);
          this._userModel.value = _user;
        } catch (e) {
          print('error catched 2');
          print(e);
        }
      }
      print(_userModel.value?.uid);
    }
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
    print("got into setpin");
    if (_userModel.value?.archivesPin == null) {
      print("arrived through null check");
      _userModel.update((val) {
        val!.archivesPin = pin.hashCode;
      });
      updatePin(pin);
      return true;
    }
    return false;
  }

  void updatePin(int pin) async {
    print("got in to update pin");
    await Database().updateArchivesPin(uid: _userModel.value!.uid, newPin: pin);
  }
}
