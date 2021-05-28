import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/pin_set_controller.dart';
import 'package:notes_app/src/ui/screens/app/archives_screen.dart';
import 'package:notes_app/src/ui/screens/app/home_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/biometric_box.dart';
import 'package:notes_app/src/ui/widgets/continue_button.dart';

class PinSetScreen extends StatelessWidget {
  static final String id = "/archives/pin_set";
  final PinSetController _pinSetController = Get.put(PinSetController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 20,
        leading: Container(
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: IconButton(
            splashRadius: 25,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Set Up Archive",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      // TODO Add Animation
      body: Obx(
        () => Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: Get.width / 20, vertical: Get.height / 45),
          child: _pinSetController.stage.value == 3
              ? SingleChildScrollView(
                  child: Container(
                    height: 35 * Get.height / 45,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 130,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Congratulations",
                          style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Your All set!",
                          style: TextStyle(fontSize: 22),
                        ),
                        Spacer(),
                        BiometricBox(),
                        Spacer(),
                        ContinueButton(onPressed: () {
                          Get.offNamedUntil(ArchivesScreen.id, ModalRoute.withName(HomeScreen.id));
                        })
                      ],
                    ),
                  ),
                )
              : FirstTwoTimes(pinSetController: _pinSetController),
        ),
      ),
    );
  }
}

class FirstTwoTimes extends StatelessWidget {
  const FirstTwoTimes({
    Key? key,
    required PinSetController pinSetController,
  })  : _pinSetController = pinSetController,
        super(key: key);

  final PinSetController _pinSetController;

  @override
  Widget build(BuildContext context) {
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
            obscureText: _pinSetController.hidePin.value,
            autofocus: true,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: textFieldDecoration.copyWith(
              hintText: "",
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
        SizedBox(
          height: 25,
        ),
        Obx(
          () => _pinSetController.invalidInput.value
              ? Text(
                  _pinSetController.errorMessage.value,
                  style: TextStyle(color: Colors.redAccent, fontSize: 17),
                  textAlign: TextAlign.center,
                )
              : Container(),
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
