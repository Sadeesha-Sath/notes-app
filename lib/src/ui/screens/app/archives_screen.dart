import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/archives_auth_controller.dart';

class ArchivesScreen extends StatelessWidget {
  static final String id = "/archives";
  final ArchivesAuthController _archivesAuthController = Get.find<ArchivesAuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Get.width / 30, vertical: Get.height / 45),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Get.back(),
                ),
              ),
              CircleAvatar(
                radius: 120,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Get.width / 60),
                child: Text(
                  "Keep Your Notes to with you",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Get.width / 60),
                child: Text(
                  "A secure, encrypted space for your most Confidential notes. Unlocked and decrypted only by a pin or your biometrics.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: InkWell(
                  onTap: () => _archivesAuthController.toggleBiometricsActiveState(),
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 15,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.fingerprint_rounded,
                          color: Colors.grey.shade700,
                          size: 50,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Use Biometrics",
                              style: TextStyle(fontSize: 16),
                            ),
                            Obx(
                              () => Switch.adaptive(
                                value: _archivesAuthController.isBiometActive.value,
                                onChanged: (bool value) => _archivesAuthController.toggleBiometricsActiveState(value),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 85 + Get.width / 60),
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                    ),
                    onPressed: () {},
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
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
