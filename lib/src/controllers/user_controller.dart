import 'package:encrypt/encrypt.dart' as enc;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/models/user.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/services/encrypter_class.dart';

class UserController extends GetxController {
  Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  Rx<User?> _currentUser = Rx(Get.find<FirebaseAuthController>().user.value);

  User? get user => _currentUser.value;
  UserModel? get userModel => _userModel.value;

  @override
  onInit() async {
    _currentUser.bindStream(Get.find<FirebaseAuthController>().user.stream);
    if (user?.uid != null) {
      setUser(user);
    }

    ever(_currentUser, setUser);

    super.onInit();
  }

  void setUser(User? user) async {
    if (user != null) {
      try {
        print("getting user data from database");

        _userModel.value = await Database.getUser(user.uid);
        print("getting user data successful");
      } catch (e) {
        print('error catched 1');
        print(e);
        UserModel _user = UserModel(
          name: user.displayName ?? user.email!.trim().split("@")[0],
          uid: user.uid,
        );
        print("created model");
        try {
          print('creating a new user');
          await Database.createNewUser(_user);
          this._userModel.value = _user;
        } catch (e) {
          print('error catched 2');
          print(e);
        }
      }
      print(_userModel.value?.uid);
    }
  }

  void updateName(String name) {
    _userModel.update((val) {
      val!.name = name;
    });
  }

  void clear() {
    _userModel.value = null;
  }

  bool isPinSet() {
    if (_userModel.value?.protectedSpacePin == null) return false;
    return true;
  }

  bool isPinCorrect(String pin) {
    if (pin == _userModel.value!.protectedSpacePin) return true;
    return false;
  }

  Future<bool> setPin(int pin) async {
    String hashedPin = EncrypterClass.hashGenerator(pin: pin);
    print("got into setpin");
    if (_userModel.value?.protectedSpacePin == null) {
      print("arrived through null check");
      _userModel.update((val) {
        val!.protectedSpacePin = hashedPin;
      });
      print(hashedPin);
      // generating an iv when the Protected-Space is initialized
      // this iv will never change
      enc.IV iv = await EncrypterClass.getNewIv;
      EncrypterClass.loadIv(iv.base64);
      await Database.updateIV(uid: userModel!.uid, iv: iv.base64);
      updatePin(hashedPin);
      return true;
    } else if (isPinCorrect(hashedPin)) {
      _userModel.update((val) {
        val!.protectedSpacePin = hashedPin;
      });
      updatePin(hashedPin);
      return true;
    }
    return false;
  }

  void updatePin(String pin) async {
    print("got in to update pin");
    await Database.updateprotectedSpacePin(uid: _userModel.value!.uid, newPin: pin);
  }
}
