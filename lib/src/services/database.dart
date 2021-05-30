import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/models/user.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.uid).set({
        "archivesPin": user.archivesPin,
        "profileData": user.userData,
        "uid": user.uid,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot _doc = await _firestore.collection("users").doc(uid).get();

      return UserModel.fromDocumentSnapshot(documentSnapshot: _doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<List<NoteModel>> noteStream({required String uid, required String collectionName}) {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection(collectionName)
        .orderBy("dateCreated", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<NoteModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(NoteModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Future<void> updateNote(
      {required String uid,
      required String collectionName,
      required NoteModel oldModel,
      required NoteModel newModel}) async {
    try {
      Map<String, dynamic> updateFields = {};
      if (oldModel.isFavourite != newModel.isFavourite) {
        updateFields["isFavourite"] = newModel.isFavourite;
      }
      if (oldModel.body != newModel.body) {
        updateFields['body'] = newModel.body;
      }
      if (oldModel.title != newModel.title) {
        updateFields['title'] = newModel.title;
      }
      _firestore.collection("users").doc(uid).collection(collectionName).doc(oldModel.noteId).update(updateFields);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
