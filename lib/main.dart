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
import 'package:notes_app/src/ui/screens/auth/login_screen.dart';
import 'package:notes_app/src/ui/screens/auth/register_screen.dart';
import 'package:notes_app/src/ui/screens/auth/start_screen.dart';
import 'package:notes_app/src/ui/widgets/auth/loading.dart';
import 'package:notes_app/src/ui/widgets/auth/something_went_wrong.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var preferences = await PreferencesHandler().readPreferences();
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
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(home: SomethingWentWrong());
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return GetMaterialApp(
              title: 'Notes App',
              home: GetBuilder<FirebaseAuthController>(
                autoRemove: false,
                init: FirebaseAuthController(),
                builder: (_) {
                  return Loading();
                },
              ),
              getPages: [
                GetPage(name: StartScreen.id, page: () => StartScreen()),
                GetPage(name: LoginScreen.id, page: () => LoginScreen()),
                GetPage(name: RegisterScreen.id, page: () => RegisterScreen()),
                GetPage(name: HomeScreen.id, page: () => HomeScreen()),
                GetPage(name: ProfileScreen.id, page: () => ProfileScreen()),
                GetPage(name: LockedNotesScreen.id, page: () => LockedNotesScreen()),
                GetPage(name: PinSetScreen.id, page: () => PinSetScreen()),
                GetPage(name: UnlockLockedNotesScreen.id, page: () => UnlockLockedNotesScreen()),
                GetPage(name: TrashScreen.id, page: () => TrashScreen()),
                GetPage(name: EditProfileScreen.id, page: () => EditProfileScreen()),
                GetPage(name: FavouritesScreen.id, page: () => FavouritesScreen()),
              ],
              theme: InheritedPreferences.of(context)!.preferences['isNightMode']!
                  ? ThemeData.dark()
                  : ThemeData(
                      primarySwatch: Colors.blue,
                    ),
            );
          }

          return MaterialApp(home: Loading());
        });

  }
}
// TODO Use dismissable widget instead of the drag controller
// TODO Implement search functionality
