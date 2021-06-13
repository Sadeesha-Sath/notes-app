import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/pin_set_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/services/database.dart';
import 'package:notes_app/src/ui/screens/app/locked_notes_screen.dart';
import 'package:notes_app/src/ui/screens/app/home_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/biometric_box.dart';
import 'package:notes_app/src/ui/widgets/continue_button.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';

class PinSetScreen extends StatelessWidget {
  static final String id = "/archives_init/pin_set";
  final PinSetController _pinSetController = Get.put(PinSetController());
  final NoteModel? noteModel = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 20,
        leading: Container(
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: CustomBackButton(),
        ),
        centerTitle: true,
        title: Text(
          "Set Up Protected Space",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: Get.width / 20, vertical: Get.height / 45),
        child: Obx(
          () => AnimatedSwitcher(
            duration: Duration(milliseconds: 350),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity:
                    CurvedAnimation(curve: Curves.easeInOutQuad, parent: animation, reverseCurve: Curves.easeInCubic),
                child: child,
              );
            },
            child: _pinSetController.stage.value == 3
                ? SingleChildScrollView(
                    child: Container(
                      height: 35 * Get.height / 45,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 130,
                          ),
                          kSizedBox25,
                          Text(
                            "Congratulations",
                            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Your All set!",
                            style: TextStyle(fontSize: 22),
                          ),
                          Spacer(),
                          BiometricBox(
                            key: ValueKey('biometrics'),
                          ),
                          Spacer(),
                          ContinueButton(onPressed: () async {
                            print(noteModel);
                            if (noteModel != null) {
                              print(noteModel?.noteId);
                              print('transferring');

                              Database.transferNote(
                                  uid: Get.find<UserController>().user!.uid,
                                  toCollection: 'locked',
                                  fromCollection: 'notes',
                                  noteModel: noteModel!);
                            }
                            Get.offNamedUntil(LockedNotesScreen.id, ModalRoute.withName(HomeScreen.id));
                          })
                        ],
                      ),
                    ),
                  )
                : FirstTwoTimes(),
          ),
        ),
      ),
    );
  }
}

class FirstTwoTimes extends StatelessWidget {
  FirstTwoTimes({Key? key}) : super(key: key);

  final PinSetController _pinSetController = Get.find<PinSetController>();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    _focusNode.requestFocus();
    return Column(
      children: [
        Spacer(
          flex: 3,
        ),
        Obx(
          () => Text(
            _pinSetController.stage.value == 1 ? "Enter a Pin" : "Retype the Pin",
            style: TextStyle(fontSize: 27),
          ),
        ),
        Spacer(),
        Obx(
          () => TextField(
            style: TextStyle(fontSize: 22),
            controller: _pinSetController.stage.value == 1 ? _pinSetController.pin1 : _pinSetController.pin2,
            onSubmitted: (String string) {
              _pinSetController.isInt(string);
            },
            obscureText: _pinSetController.hidePin.value,
            focusNode: _focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: textFieldDecoration.copyWith(
              suffixIcon: IconButton(
                splashRadius: 20,
                onPressed: () {
                  _pinSetController.pinVisibilityToggle();
                },
                icon: Icon(_pinSetController.hidePin.value ? Icons.visibility_rounded : Icons.visibility_off_rounded),
              ),
            ),
          ),
        ),
        kSizedBox25,
        Obx(
          () => Visibility(
            visible: _pinSetController.invalidInput.value,
            child: Text(
              _pinSetController.errorMessage.value,
              style: TextStyle(color: Colors.redAccent, fontSize: 17),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Spacer(
          flex: 6,
        ),
        ContinueButton(
          onPressed: () {
            _pinSetController
                .isInt(_pinSetController.stage.value == 1 ? _pinSetController.pin1.text : _pinSetController.pin2.text);
          },
        ),
      ],
    );
  }
}
