import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';

class Storage {
  static final _storage = FirebaseStorage.instance;

  static Future<void> addProfileImage() async {
    // TODO add filename
    _storage.ref('users/' + Get.find<UserController>().user!.uid + '').putFile(File('//path//'));
  }
}
