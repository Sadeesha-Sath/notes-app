import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:notes_app/src/ui/screens/app/archives_screen.dart';
import 'package:notes_app/src/ui/screens/app/home_screen.dart';
import 'package:notes_app/src/ui/screens/app/pin_set_screen.dart';
import 'package:notes_app/src/ui/screens/app/profile_screen.dart';
import 'package:notes_app/src/ui/screens/auth/login_screen.dart';
import 'package:notes_app/src/ui/screens/auth/register_screen.dart';
import 'package:notes_app/src/ui/screens/auth/start_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Notes App',
      initialRoute: StartScreen.id,
      getPages: [
        GetPage(name: StartScreen.id, page: () => StartScreen()),
        GetPage(name: LoginScreen.id, page: () => LoginScreen()),
        GetPage(name: RegisterScreen.id, page: () => RegisterScreen()),
        GetPage(name: HomeScreen.id, page: () => HomeScreen()),
        GetPage(name: ProfileScreen.id, page: () => ProfileScreen()),
        GetPage(name: ArchivesScreen.id, page: () => ArchivesScreen()),
        GetPage(name: PinSetScreen.id, page: () => PinSetScreen()),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
