import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/models/user.dart';
import 'package:notes_app/src/models/user_data.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/screens/app/home_screen.dart';
import 'package:notes_app/src/ui/screens/auth/start_screen.dart';

class FirebaseAuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> _firebaseUser;

  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    _firebaseUser = _auth.currentUser.obs;
    _firebaseUser.bindStream(_auth.authStateChanges());

    ever(_firebaseUser, checkUser);

    super.onInit();
  }

  void checkUser(User? user) {
    if (user != null) {
      Get.offNamed(HomeScreen.id);
    } else {
      Get.offNamed(StartScreen.id);
    }
  }

  void registerUser(String email, String password) async {
    try {
      var _authResult = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      print("Created User $email");
      UserModel _user = UserModel(
        userData: UserData(
          email: email.trim(),
          name: email.trim().split("@")[0],
          profileUrl: _authResult.user!.photoURL!,
        ),
        uid: _authResult.user!.uid,
      );
      if (await Database().createNewUser(_user)) {
        Get.find<UserController>().user = _user;
        Get.offAllNamed(HomeScreen.id);
      }
    } catch (e) {
      Get.snackbar("Creating User Account was Unsuccessful", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void loginUser(String email, String password) async {
    try {
      var _authResult = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      Get.find<UserController>().user =
          await Database().getUser(_authResult.user!.uid);
      print("logged User $email");
      Get.offAllNamed(HomeScreen.id);
    } catch (e) {
      Get.snackbar("Logging In was Unsuccessful", "$e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signOutUser() async {
    try {
      print("User ${_firebaseUser.value?.email}");
      await _auth.signOut();
      Get.find<UserController>().clear();
      print("Signed out user");
      Get.offAllNamed(StartScreen.id);
    } catch (e) {
      Get.snackbar("Unable to Sign Out", "$e", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
