import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/user_controller.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncrypterClass {
  static String protectedSpacePin = Get.find<UserController>().userModel!.protectedSpacePin!;
  static var key1 = encrypt.Key.fromUtf8(hashGenerator(string: protectedSpacePin));
  static final key2 = encrypt.Key.fromUtf8(dotenv.env['APP_SPECIFIC_SECRET_KEY']!);
  static var iv = Get.find<UserController>().userModel!.iv;
  static var masterKey =
      encrypt.Key.fromBase16(encrypt.Key.fromUtf8(key1.base64 + key2.base64).base16.substring(111, 143));
  static var encrypter = encrypt.Encrypter(encrypt.AES(masterKey));

  static changePin() {
    protectedSpacePin = Get.find<UserController>().userModel!.protectedSpacePin!;
    key1 = encrypt.Key.fromUtf8(hashGenerator(string: protectedSpacePin));
    masterKey = encrypt.Key.fromBase16(encrypt.Key.fromUtf8(key1.base64 + key2.base64).base16.substring(111, 143));
    encrypter = encrypt.Encrypter(encrypt.AES(masterKey));
  }

  static String hashGenerator({int? pin, String? string}) {
    late var bytes;
    if (pin != null) {
      assert(string == null);
      bytes = utf8.encode(pin.toRadixString(int.parse(dotenv.env['RADIX']!)));
    } else {
      assert(string != null);
      bytes = utf8.encode(string!);
    }

    var digest = sha512.convert(bytes);

    // print("Digest as bytes: ${digest.bytes}");
    // print("Digest as hex string: $digest");
    return digest.toString();
  }

  static get getNewIv => encrypt.IV.fromSecureRandom(16);

  static void loadIv(String? newIv) {
    // print(key1.base64);
    // print(key2.base64);
    // print(masterKey.length);
    // print("MasterKey :-   ${masterKey.base64}");
    if (iv != null)
      iv = Get.find<UserController>().userModel!.iv;
    else
      iv = newIv;
  }

  String encryptText({required String string}) {
    final encrypted = encrypter.encrypt(string, iv: encrypt.IV.fromBase64(iv!));
    // print("IV:    ${encrypt.IV.fromBase64(iv!).base64}");
    // print(encrypted.bytes);
    // print(encrypted.base16);
    // print(encrypted.base64);
    return encrypted.base64;
  }

  String decryptText({required String string}) {
    return encrypter.decrypt(encrypt.Encrypted.fromBase64(string), iv: encrypt.IV.fromBase64(iv!));
  }
}
