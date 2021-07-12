import 'package:encrypt/encrypt.dart' as enc;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
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

  @override
  void onClose() {
    try {
      _userModel.close();
      _currentUser.close();
    } catch (e) {
      print(e);
    }
    super.onClose();
  }

  void setUser(User? user) async {
    if (user != null) {
      try {
        _userModel.value = await Database.getUser(user.uid);
      } catch (e) {
        print('error catched 1 :  $e');
        UserModel _user = UserModel(
          name: user.displayName ?? user.email!.trim().split("@")[0],
          uid: user.uid,
        );
        try {
          await Database.createNewUser(_user);
          this._userModel.value = _user;
        } catch (e) {
          print('error catched 2 :   $e');
        }
      }
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

  bool isPinCorrect(int pin) {
    if (EncrypterClass.hashGenerator(pin: pin) == _userModel.value!.protectedSpacePin) return true;
    return false;
  }

  Future<bool> setPin(int pin) async {
    String hashedPin = EncrypterClass.hashGenerator(pin: pin);
    if (_userModel.value?.protectedSpacePin == null) {
      _userModel.update((val) {
        val!.protectedSpacePin = hashedPin;
      });
      // generating an iv when the Protected-Space is initialized
      // this iv will never change
      enc.IV iv = await EncrypterClass.getNewIv;
      EncrypterClass.loadIv(iv.base64);
      await Database.updateIV(uid: userModel!.uid, iv: iv.base64);
      updatePin(hashedPin);
      return true;
    }
    _userModel.update((val) {
      val!.protectedSpacePin = hashedPin;
    });
    var _notesController = Get.find<NotesController>();
    if (_notesController.lockedNotes != null) {
      // Changing encrypter for re-encryption
      await EncrypterClass.changePin();
      for (var note in _notesController.lockedNotes!) {
        Database.updateNote(
            uid: _userModel.value!.uid, collectionName: 'locked', oldModel: note, newModel: note, isForced: true);
      }
    }
    updatePin(hashedPin);
    return true;
  }

  void updatePin(String pin) async {
    await Database.updateProtectedSpacePin(uid: _userModel.value!.uid, newPin: pin);
  }
}
