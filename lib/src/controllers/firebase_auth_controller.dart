import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
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
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print("Created User $email");
      Get.offAllNamed(HomeScreen.id);
    } catch (e) {
      Get.snackbar("Creating User Account was Unsuccessful", e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("logged User $email");
      Get.offAllNamed(HomeScreen.id);
    } catch (e) {
      Get.snackbar("Logging In was Unsuccessful", "$e");
    }
  }

  void signOutUser() async {
    try {
      print("User ${_firebaseUser.value?.email}");
      await _auth.signOut();
      print("Signed out user");
      Get.offAllNamed(StartScreen.id);
    } catch (e) {
      Get.snackbar("Unable to Sign Out", "$e");
    }
  }
}
