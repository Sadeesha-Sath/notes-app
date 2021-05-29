import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/ui/screens/app/archives_screen.dart';
import 'package:notes_app/src/ui/screens/app/home_screen.dart';
import 'package:notes_app/src/ui/screens/app/note_screen.dart';
import 'package:notes_app/src/ui/screens/app/pin_set_screen.dart';
import 'package:notes_app/src/ui/screens/app/profile_screen.dart';
import 'package:notes_app/src/ui/screens/auth/login_screen.dart';
import 'package:notes_app/src/ui/screens/auth/register_screen.dart';
import 'package:notes_app/src/ui/screens/auth/start_screen.dart';
import 'package:notes_app/src/ui/widgets/loading.dart';
import 'package:notes_app/src/ui/widgets/something_went_wrong.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.lazyPut<FirebaseAuthController>(() => FirebaseAuthController());
  runApp(App());
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
                GetPage(name: ArchivesScreen.id, page: () => ArchivesScreen()),
                GetPage(name: PinSetScreen.id, page: () => PinSetScreen()),
                GetPage(name: NoteScreen.id, page: () => NoteScreen()),
              ],
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
            );
          }

          return MaterialApp(home: Loading());
        });
  }
}
