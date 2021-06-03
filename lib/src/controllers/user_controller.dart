import 'package:encrypt/encrypt.dart' as enc;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/models/user.dart';
import 'package:notes_app/src/models/user_data.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/services/encrypter.dart';

class UserController extends GetxController {
  Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  Rx<User?> _currentUser = Rx(Get.find<FirebaseAuthController>().user.value);

  User? get user => _currentUser.value;
  UserModel? get userModel => _userModel.value;

  @override
  onInit() async {
    _currentUser.bindStream(Get.find<FirebaseAuthController>().user.stream);
    if (user != null) {
      setUser(user);
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

  Future<bool> setPin(int pin) async {
    print("got into setpin");
    if (_userModel.value?.archivesPin == null) {
      print("arrived through null check");
      _userModel.update((val) {
        val!.archivesPin = pin.hashCode;
      });
      // generating an iv when the archive is initialized
      // this iv will never change
      enc.IV iv = await EncrypterClass.getNewIv;
      EncrypterClass.loadIv(iv);
      await Database().updateIV(uid: _userModel.value!.uid, iv: iv);
      updatePin(pin);
      return true;
    } else if (isPinCorrect(pin)) {
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
    EncrypterClass.updateArchivesPin(pin);
    await Database().updateArchivesPin(uid: _userModel.value!.uid, newPin: pin);
  }
}
