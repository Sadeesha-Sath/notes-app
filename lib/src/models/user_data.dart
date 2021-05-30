import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String email;
  String name;
  String profileUrl;

  UserData({required this.email, required this.name, required this.profileUrl});

  UserData.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) :
    email = documentSnapshot['email'],
    name = documentSnapshot['name'],
    profileUrl = documentSnapshot['profileUrl'];
  
}
