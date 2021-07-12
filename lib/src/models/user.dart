import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? protectedSpacePin;
  String name;
  String uid;
  String? iv;

  UserModel({this.protectedSpacePin, required this.uid, this.iv, required this.name});

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot, uid})
      : uid = documentSnapshot.id,
        protectedSpacePin = documentSnapshot['protectedSpacePin'],
        name = documentSnapshot['name'],
        iv = documentSnapshot['iv'];
}
