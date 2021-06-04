import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/src/models/user_data.dart';

class UserModel {
  String? protectedSpacePin;
  UserData userData;
  String uid;
  String? iv;

  UserModel({this.protectedSpacePin, required this.userData, required this.uid, this.iv});

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot, uid})
      : uid = documentSnapshot.id,
        protectedSpacePin = documentSnapshot['protectedSpacePin'],
        userData = UserData.fromDocumentSnapshot(documentSnapshot['profileData']),
        iv = documentSnapshot['iv'] {
    print("successful");
  }
}
