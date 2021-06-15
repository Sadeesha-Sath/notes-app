import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/file_handlers/inherited_preferences.dart';
import 'package:notes_app/src/file_handlers/preferences_handler.dart';
import 'package:notes_app/src/ui/screens/app/edit_profile_screen.dart';
import 'package:notes_app/src/ui/screens/app/favourites_screen.dart';
import 'package:notes_app/src/ui/screens/app/locked_notes_screen.dart';
import 'package:notes_app/src/ui/screens/app/home_screen.dart';
import 'package:notes_app/src/ui/screens/app/pin_set_screen.dart';
import 'package:notes_app/src/ui/screens/app/profile_screen.dart';
import 'package:notes_app/src/ui/screens/app/trash_screen.dart';
import 'package:notes_app/src/ui/screens/app/unlock_locked_notes_screen.dart';
import 'package:notes_app/src/ui/screens/auth/forgot_password_screen.dart';
import 'package:notes_app/src/ui/screens/auth/login_screen.dart';
import 'package:notes_app/src/ui/screens/auth/register_screen.dart';
import 'package:notes_app/src/ui/screens/auth/start_screen.dart';
import 'package:notes_app/src/ui/widgets/auth/loading.dart';
import 'package:notes_app/src/ui/widgets/auth/something_went_wrong.dart';
import 'package:notes_app/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var preferences = await PreferencesHandler().readPreferences();
  // get secret data from .env
  await dotenv.load();
  Get.lazyPut<FirebaseAuthController>(() => FirebaseAuthController());
  runApp(
    InheritedPreferences(
      preferences: preferences,
      child: App(),
    ),
  );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    // Make sure that the inherited preference default to the system theme
    final Future _initialization = dataInitialization(InheritedPreferences.of(context)!);
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(home: SomethingWentWrong());
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return GetMaterialApp(
              themeMode:
                  InheritedPreferences.of(context)!.preferences['isNightMode']! ? ThemeMode.dark : ThemeMode.light,
              darkTheme: ThemeData.dark(),
              title: 'Notes App',
              home: GetBuilder<FirebaseAuthController>(
                autoRemove: false,
                init: FirebaseAuthController(),
                builder: (_) {
                  // The init method in firbase auth controller checks for any user and redirect accordingly. So no need to implement it here.
                  return Loading();
                },
              ),
              getPages: [
                GetPage(
                  name: StartScreen.id,
                  page: () => StartScreen(),
                  transition: Transition.fadeIn,
                  transitionDuration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                ),
                GetPage(
                  name: LoginScreen.id,
                  page: () => LoginScreen(),
                  transition: Transition.rightToLeft,
                  transitionDuration: Duration(milliseconds: 280),
                  curve: Curves.easeInOut,
                ),
                GetPage(
                  name: ForgotPasswordScreen.id,
                  page: () => ForgotPasswordScreen(),
                  transition: Transition.downToUp,
                  transitionDuration: Duration(milliseconds: 420),
                  curve: Curves.easeInOut,
                ),
                GetPage(
                    name: RegisterScreen.id,
                    page: () => RegisterScreen(),
                    transition: Transition.rightToLeft,
                    curve: Curves.easeInOut,
                    transitionDuration: Duration(milliseconds: 280)),
                GetPage(
                  name: HomeScreen.id,
                  page: () => HomeScreen(),
                  transition: Transition.fadeIn,
                  transitionDuration: Duration(milliseconds: 400),
                  curve: Curves.easeIn,
                ),
                GetPage(
                  name: ProfileScreen.id,
                  page: () => ProfileScreen(),
                  transition: Transition.rightToLeft,
                  transitionDuration: Duration(milliseconds: 330),
                  curve: Curves.easeInOut,
                ),
                GetPage(
                  name: LockedNotesScreen.id,
                  page: () => LockedNotesScreen(),
                  transition: Transition.downToUp,
                  transitionDuration: Duration(milliseconds: 420),
                  curve: Curves.easeInOut,
                ),
                GetPage(
                  name: PinSetScreen.id,
                  page: () => PinSetScreen(),
                  transition: Transition.rightToLeft,
                  transitionDuration: Duration(milliseconds: 330),
                  curve: Curves.easeInOut,
                ),
                GetPage(
                  name: UnlockLockedNotesScreen.id,
                  page: () => UnlockLockedNotesScreen(),
                  transition: Transition.rightToLeft,
                  transitionDuration: Duration(milliseconds: 330),
                  curve: Curves.easeInOut,
                ),
                GetPage(
                  name: TrashScreen.id,
                  page: () => TrashScreen(),
                  transition: Transition.rightToLeft,
                  transitionDuration: Duration(milliseconds: 330),
                  curve: Curves.easeInOut,
                ),
                GetPage(
                  name: EditProfileScreen.id,
                  page: () => EditProfileScreen(),
                  transition: Transition.rightToLeft,
                  transitionDuration: Duration(milliseconds: 330),
                  curve: Curves.easeInOut,
                ),
                GetPage(
                  name: FavouritesScreen.id,
                  page: () => FavouritesScreen(),
                  transition: Transition.rightToLeft,
                  transitionDuration: Duration(milliseconds: 330),
                  curve: Curves.easeInOut,
                ),
              ],
              theme: lightTheme,
            );
          }

          return MaterialApp(home: Loading());
        });
  }

  Future dataInitialization(InheritedPreferences inheritedPreferences) async {
    var initialValue = inheritedPreferences.preferences;
    if (initialValue['isNightMode'] == null) {
      if (ThemeMode.system == ThemeMode.dark) {
        setState(() {
          inheritedPreferences.preferences['isNightMode'] = true;
        });
        PreferencesHandler().updatePreferences(
            preferences: {'isNightMode': true, 'isBiometricEnabled': initialValue['isBiometricEnabled']});
      } else {
        setState(() {
          inheritedPreferences.preferences['isNightMode'] = false;
        });
        PreferencesHandler().updatePreferences(
            preferences: {'isNightMode': false, 'isBiometricEnabled': initialValue['isBiometricEnabled']});
      }
    }
    await Firebase.initializeApp();
  }
}


// TODO Get access in ios using xcode