import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/file_handlers/inherited_preferences.dart';
import 'package:notes_app/src/ui/screens/app/locked_notes_screen.dart';
import 'package:notes_app/src/ui/widgets/locked_notes_init.dart';

class UnlockLockedNotesScreen extends StatelessWidget {
  static final String id = "/unlock_locked_notes";
  final arguments = Get.arguments;

  @override
  Widget build(BuildContext context) {
    print(arguments);
    return Scaffold(
      body: SafeArea(
        child: Get.find<UserController>().isPinSet()
            ? UnlockWithBiometricOrPin()

            // TODO Implement locked pin/biometrics
            : LockedNotesInit(noteModel: arguments),
      ),
    );
  }
}

class UnlockWithBiometricOrPin extends StatefulWidget {
  const UnlockWithBiometricOrPin({Key? key}) : super(key: key);

  @override
  _UnlockWithBiometricOrPinState createState() => _UnlockWithBiometricOrPinState();
}

class _UnlockWithBiometricOrPinState extends State<UnlockWithBiometricOrPin> {
  late Future<bool> isBiometric;
  final _localAuth = LocalAuthentication();
  var usePin = false.obs;

  @override
  Widget build(BuildContext context) {
    isBiometric = _localAuth.canCheckBiometrics;

    return Container(
      padding: EdgeInsets.all(25),
      alignment: Alignment.center,
      child: FutureBuilder(
          future: isBiometric,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              bool isBioEnabled = snapshot.data as bool;
              if (isBioEnabled) {
                isBioEnabled = InheritedPreferences.of(context)!.preferences['isBiometricEnabled'] ?? false;
              }
              return Column(
                children: [
                  Spacer(
                    flex: 3,
                  ),
                  CircleAvatar(
                    radius: 110,
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Text(
                    "Welcome to Your Private and Secure Space",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(
                    flex: 4,
                  ),
                  if (isBioEnabled)
                    Card(
                      elevation: 1,
                      color: Color(0xFFA2D1F6),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          bool isAuthenticated = await _localAuth.authenticate(
                            localizedReason: "Access your Vault",
                            biometricOnly: true,
                            stickyAuth: true,
                          );
                          if (isAuthenticated) {
                            Get.off(LockedNotesScreen.id);
                          } else {
                            usePin(true);
                          }
                        },
                        child: Container(
                          width: Get.width - 100,
                          height: 160,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fingerprint_rounded,
                                  size: 40,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Use Biometrics",
                                  style: TextStyle(fontSize: 19),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    )
                  else
                    Spacer(
                      flex: 2,
                    ),
                  Spacer(
                    flex: 2,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 18, vertical: 10)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    ),
                    onPressed: () {
                      if (!usePin.value)
                        usePin(true);
                      else {}
                    },
                    child: Text(
                      usePin.value ? "Show me" : "Use Pin Instead",
                      style: TextStyle(fontSize: 19),
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Oh no, Something has gone wrong. Please try again in a bit',
                  style: TextStyle(fontSize: 19),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          }),
    );
  }
}
