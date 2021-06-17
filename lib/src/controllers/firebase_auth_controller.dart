import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/ui/screens/app/home_screen.dart';
import 'package:notes_app/src/ui/screens/auth/start_screen.dart';

class FirebaseAuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> _firebaseUser;
  Rx<User?> _userIdchanges = Rx(null);

  // User? get user => _firebaseUser.value;
  Rx<User?> get user => _firebaseUser;
  User? get userTokenChanges => _userIdchanges.value;
  // FirebaseAuth get auth => _auth;
  bool isInitialized = false;

  @override
  void onInit() {
    _firebaseUser = _auth.currentUser.obs;
    _firebaseUser.bindStream(_auth.authStateChanges());
    _userIdchanges.bindStream(_auth.userChanges());
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
      isInitialized = true;
      Get.offAllNamed(HomeScreen.id);
    } else {
      isInitialized = true;
      Get.offAllNamed(StartScreen.id);
    }
  }

  Future<void> registerUser(String email, String password, String name) async {
    try {
      var response = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      await response.user!.updateDisplayName(name == "" ? email.trim().split("@")[0] : name);
    } catch (e) {
      print(e);
      Get.snackbar("Creating User Account was Unsuccessful", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> loginUser(String email, String password, Rx<String?> error) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    } catch (e) {
      var errorType = e.toString().split("]").first.split("/").last;

      if (errorType == "invalid-email")
        error.value = "The email you entered is invalid. Please enter a valid email address.";
      else if (errorType == "wrong-password")
        error.value = "The password is invalid or the user does not have a password.";
      else if (errorType == "user-disabled")
        error.value = "This user has disabled the account. Please enable it to continue.";
      else if (errorType == "user-not-found")
        error.value =
            "There are no accounts connected to this email. Please check your email address or register a new account.";
      else {
        error.value = e.toString();
        Get.snackbar("Logging In was Unsuccessful", "$e", snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void signOutUser() async {
    try {
      print("User ${_firebaseUser.value?.email}");
      await _auth.signOut();

      print("Signed out user");
      Get.offAllNamed(StartScreen.id);
    } catch (e) {
      print(e);
      Get.snackbar("Unable to Sign Out", "$e", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
