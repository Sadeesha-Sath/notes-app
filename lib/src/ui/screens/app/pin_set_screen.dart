import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/pin_set_controller.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class PinSetScreen extends StatelessWidget {
  static final String id = "/archives/pin_set";
  final PinSetController _pinSetController = Get.put(PinSetController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Set Up Archive",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width / 20, vertical: Get.height / 45),
        child: Column(
          children: [
            Spacer(
              flex: 3,
            ),
            Text(
              "Enter a Pin",
              style: TextStyle(fontSize: 27),
            ),
            Spacer(),
            Obx(
              () => TextField(
                onChanged: (value) => _pinSetController.pin1 = value,
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
                    icon:
                        Icon(_pinSetController.hidePin.value ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                  ),
                ),
              ),
            ),
            // Obx(
            //   () => _pinSetController.invalidInput.value ? Text(_pinSetController.errorMessage.value) : Container(),
            // ),
            // TODO Figure out a way to change pages with animation
            Spacer(
              flex: 6,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 85 + Get.width / 60),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                ),
                onPressed: () {
                  _pinSetController.isInt(_pinSetController.pin1);
                },
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  title: Text(
                    "Continue",
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
