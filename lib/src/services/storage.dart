import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:notes_app/src/extensions/file_extension.dart';

class Storage {
  static final _storage = FirebaseStorage.instance;

  static Future<void> addProfileImage(File imageFile) async {
    if (imageFile.existsSync()) {
      final fileExt = imageFile.fileType;
      try {
        await deleteProfileImage();
        var user = Get.find<UserController>().user;

        var response = await _storage.ref('users/${user!.uid}/profileImage.$fileExt').putFile(imageFile);

        var url = await response.ref.getDownloadURL();

        await user.updatePhotoURL(url);
        await user.reload();
      } catch (e) {
        print('error $e');
      }
    } else {
      print("File does not exist.");
    }
  }

  static Future<void> deleteProfileImage() async {
    if (Get.find<FirebaseAuthController>().userTokenChanges?.photoURL != null) {
      await _storage.refFromURL(Get.find<FirebaseAuthController>().userTokenChanges!.photoURL!).delete();
      await Get.find<UserController>().user!.updatePhotoURL(null);
    }
  }
}
