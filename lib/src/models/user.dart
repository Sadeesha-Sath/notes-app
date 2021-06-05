import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? protectedSpacePin;

  String uid;
  String? iv;

  UserModel({this.protectedSpacePin, required this.uid, this.iv});

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot, uid})
      : uid = documentSnapshot.id,
        protectedSpacePin = documentSnapshot['protectedSpacePin'],
        iv = documentSnapshot['iv'] {
    print("successful");
  }
}
