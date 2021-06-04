import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/src/models/user_data.dart';

class UserModel {
  String? archivesPin;
  UserData userData;
  String uid;
  String? iv;

  UserModel({this.archivesPin, required this.userData, required this.uid, this.iv});

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot, uid})
      : uid = documentSnapshot.id,
        archivesPin = documentSnapshot['archivesPin'],
        userData = UserData.fromDocumentSnapshot(documentSnapshot['profileData']),
        iv = documentSnapshot['iv'] {
    print("successful");
  }
}
