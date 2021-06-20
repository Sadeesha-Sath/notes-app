import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/controllers/rating_controller.dart';
import 'package:notes_app/src/services/local_preferences.dart';
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
import 'package:rate_my_app/rate_my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalPreferences.onInit();
  // get secret data from .env
  await dotenv.load();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Get.lazyPut<FirebaseAuthController>(() => FirebaseAuthController());
  Get.lazyPut<RatingController>(() => RatingController());
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    // Make sure that the inherited preference default to the system theme
    final Future _initialization = Firebase.initializeApp();
    // Make shared preference dark mode setting to be system default if not set
    dataInit();
    return GetMaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: LocalPreferences.isDarkMode! ? ThemeMode.dark : ThemeMode.light,
      title: 'Notes App',
      home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              SomethingWentWrong();
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return GetBuilder<FirebaseAuthController>(
                autoRemove: false,
                init: Get.find<FirebaseAuthController>(),
                builder: (controller) {
                  // The init method in firebase auth controller checks for any users and redirect accordingly. This check is useful for hot reload only.
                  if (controller.isInitialized) {
                    if (controller.user.value == null)
                      return StartScreen();
                    else
                      return HomeScreen();
                  }
                  return Loading();
                },
              );
            }

            return Loading();
          }),
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
    );
  }

  void dataInit() async {
    if (LocalPreferences.isDarkMode == null) {
      if (ThemeMode.system == ThemeMode.dark) {
        setState(() {
          LocalPreferences.isDarkMode = true;
        });
      } else {
        setState(() {
          LocalPreferences.isDarkMode = false;
        });
      }
    }
  }

// TODO Get access in ios using xcode and integrate apple sign in
}

class RateAppInitWidget extends StatefulWidget {
  final Widget Function(RateMyApp) builder;

  const RateAppInitWidget({Key? key, required this.builder});

  @override
  _RateAppInitWidgetState createState() => _RateAppInitWidgetState();
}

class _RateAppInitWidgetState extends State<RateAppInitWidget> {
  RateMyApp? rateMyApp;

  static const playStoreId = "com.android.chrome";
  static const appStoreIdentifier = "";

  @override
  Widget build(BuildContext context) {
    return RateMyAppBuilder(
      rateMyApp: RateMyApp(appStoreIdentifier: appStoreIdentifier, googlePlayIdentifier: playStoreId),
      onInitialized: (context, rateMyApp) {
        setState(() {
          this.rateMyApp = rateMyApp;
        });
      },
      builder: (context) => rateMyApp == null ? Loading() : widget.builder(rateMyApp!),
    );
  }
}
