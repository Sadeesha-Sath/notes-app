import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/archives_auth_controller.dart';

class BiometricBox extends StatelessWidget {
  final ArchivesAuthController _archivesAuthController = Get.find<ArchivesAuthController>();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      value: _archivesAuthController.isBiometricEnabled.value,
                      onChanged: (bool value) => _archivesAuthController.toggleBiometricsActiveState(value),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
