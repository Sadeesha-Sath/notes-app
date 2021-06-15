import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PreferencesHandler {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/preferences.json');
  }

  Future<Map<String, bool?>> readPreferences() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      final decodedContents = jsonDecode(contents);
      final isNightMode = decodedContents['isNightMode'] as bool?;
      final biomet = decodedContents['isBiometricEnabled'] as bool;
      var returnContents = {"isNightMode": isNightMode, "isBiometricEnabled": biomet};

      return returnContents;
    } catch (e) {
      print(e);
      final defaultContents = {"isNightMode": null, "isBiometricEnabled": false};
      writePreferences(defaultContents);
      return defaultContents;
    }
  }

  Future<File> writePreferences(dynamic contents) async {
    final file = await _localFile;

    // Write the file
    var writecontents = jsonEncode(contents);
    return file.writeAsString(writecontents);
  }

  void updatePreferences({dynamic preferences}) async {
    print("updating");
    final updateContent = {
      "isNightMode": preferences['isNightMode'],
      "isBiometricEnabled": preferences['isBiometricEnabled']
    };
    writePreferences(updateContent);
  }
}
