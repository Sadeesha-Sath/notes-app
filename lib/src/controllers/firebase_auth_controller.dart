import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/ui/screens/app/home_screen.dart';
import 'package:notes_app/src/ui/screens/auth/start_screen.dart';

class FirebaseAuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> _firebaseUser;

  // User? get user => _firebaseUser.value;
  Rx<User?> get user => _firebaseUser;
  // FirebaseAuth get auth => _auth;

  @override
  void onInit() {
    _firebaseUser = _auth.currentUser.obs;
    _firebaseUser.bindStream(_auth.userChanges());

    ever(_firebaseUser, checkUser);

    Get.lazyPut(() => UserController());

    super.onInit();
  }

  Future sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
      return e;
    }
  }

  void checkUser(User? user) async {
    if (user != null) {
      Get.offNamed(HomeScreen.id);
    } else {
      Get.offNamed(StartScreen.id);
    }
  }

  Future<void> registerUser(String email, String password, String name) async {
    try {
      var response = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      await response.user!.updateProfile(displayName: name == "" ? email.trim().split("@")[0] : name);
    } catch (e) {
      print(e);
      Get.snackbar("Creating User Account was Unsuccessful", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    } catch (e) {
      print(e);
      Get.snackbar("Logging In was Unsuccessful", "$e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signOutUser() async {
    try {
      print("User ${_firebaseUser.value?.email}");
      await _auth.signOut();

      print("Signed out user");
      Get.offAllNamed(StartScreen.id);
      // Get.find<UserController>().clear();
    } catch (e) {
      print(e);
      Get.snackbar("Unable to Sign Out", "$e", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
