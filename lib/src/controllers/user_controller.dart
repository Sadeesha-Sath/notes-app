import 'package:get/get.dart';
import 'package:notes_app/src/models/user.dart';

class UserController extends GetxController {
  Rx<UserModel?> _userModel = Rx<UserModel?>(null);

  UserModel? get user => _userModel.value;

  set setUser(UserModel? value) => this._userModel.value = value;

  void clear() {
    _userModel.value = null;
  }
}
