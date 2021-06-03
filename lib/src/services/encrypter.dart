import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncrypterClass {
  static int archivesPin = Get.find<UserController>().userModel!.archivesPin!;
  static final key1 = encrypt.Key.fromUtf8(archivesPin.hashCode.toString());
  static final key2 = encrypt.Key.fromUtf8(dotenv.env['APP_SPECIFIC_SECRET_KEY']!);
  static var iv = Get.find<UserController>().userModel!.iv;
  static final masterKey =
      encrypt.Key.fromBase16(encrypt.Key.fromUtf8(key1.base64 + key2.base64).base16.substring(21, 53));
  static final encrypter = encrypt.Encrypter(encrypt.AES(masterKey));

  static get getNewIv => encrypt.IV.fromSecureRandom(16);

  static void loadIv(String? newIv) {
    // print(key1.base64);
    // print(key2.base64);
    // print(masterKey.length);
    print("MasterKey :-   ${masterKey.base64}");
    if (iv != null)
      iv = Get.find<UserController>().userModel!.iv;
    else
      iv = newIv;
  }

  String encryptText({required String string}) {
    final encrypted = encrypter.encrypt(string, iv: encrypt.IV.fromBase64(iv!));
    print("IV:    ${encrypt.IV.fromBase64(iv!).base64}");
    // print(encrypted.bytes);
    // print(encrypted.base16);
    // print(encrypted.base64);
    return encrypted.base64;
  }

  String decryptText({required String string}) {
    return encrypter.decrypt(encrypt.Encrypted.fromBase64(string), iv: encrypt.IV.fromBase64(iv!));
  }
}
