import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncrypterClass {
  static int archivesPin = Get.find<UserController>().userModel!.archivesPin!;
  static final key1 = encrypt.Key.fromUtf8(archivesPin.hashCode.toString());
  static final key2 = encrypt.Key.fromUtf8(dotenv.env['APP_SPECIFIC_SECRET_KEY']!);
  static final masterKey = encrypt.Key.fromUtf8(key1.base64 + key2.base64);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(masterKey));

  encrypt.Encrypted encryptText({required String string}) {
    final encrypted = encrypter.encrypt(string, iv: iv);
    print(encrypted.bytes);
    print(encrypted.base16);
    print(encrypted.base64);
    return encrypted;
  }

  String decryptText({required encrypt.Encrypted string}) {
    return encrypter.decrypt(string);
  }

  void updateArchivesPin(int pin) {
    archivesPin = pin;
  }
}
