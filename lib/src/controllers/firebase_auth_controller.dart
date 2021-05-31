import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/archives_auth_controller.dart';
import 'package:notes_app/src/controllers/drag_controller.dart';
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

  void checkUser(User? user) async {
    if (user != null) {
      Get.put(UserController()).setUser = await Database().getUser(user.uid);
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
        ),
        uid: _authResult.user!.uid,
      );
      print("Created User model");
      if (await Database().createNewUser(_user)) {
        Get.put(UserController(), permanent: true).setUser = _user;
        Get.offAllNamed(HomeScreen.id);
      }
      print("Upload Completed");
    } catch (e) {
      print(e);
      Get.snackbar("Creating User Account was Unsuccessful", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void loginUser(String email, String password) async {
    try {
      var _authResult = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      print(_authResult.user?.uid);
      Get.put(UserController()).setUser = await Database().getUser(_authResult.user!.uid);
      print("logged User $email");
      Get.offAllNamed(HomeScreen.id);
    } catch (e) {
      print(e);
      Get.snackbar("Logging In was Unsuccessful", "$e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signOutUser() async {
    try {
      print("User ${_firebaseUser.value?.email}");
      await _auth.signOut();
      Get.find<UserController>().clear();
      print("Signed out user");
      Get.find<DragController>().dispose();
      // Get.find<ArchivesAuthController>().dispose();
      Get.offAllNamed(StartScreen.id);
    } catch (e) {
      print(e);
      Get.snackbar("Unable to Sign Out", "$e", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
