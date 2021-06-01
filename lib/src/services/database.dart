import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/models/user.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      print("Creating database model");
      await _firestore.collection("users").doc(user.uid).set({
        "archivesPin": user.archivesPin,
        "profileData": user.userData.toMap(),
        "uid": user.uid,
      });
      print("uploaded to firestore");
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
        if (collectionName == 'archives') {
          retVal.add(NoteModel.fromDocSnapshotEncrypted(element));
        } else {
          retVal.add(NoteModel.fromDocumentSnapshot(element));
        }
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
      Get.snackbar(
        "Updating the note content failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<void> updateFavourite(
      {required String uid, required String collectionName, required String noteId, required bool isFavourite}) async {
    try {
      _firestore
          .collection('users')
          .doc(uid)
          .collection(collectionName)
          .doc(noteId)
          .update({"isFavourite": isFavourite});
    } catch (e) {
      print(e);
      Get.snackbar(
        "Updating the note failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<void> transferNote(
      {required String uid,
      required String toCollection,
      required String fromCollection,
      required String noteId,
      required NoteModel noteModel}) async {
    try {
      addNote(uid: uid, collectionName: toCollection, note: noteModel, noteId: noteId);
      deleteNote(uid: uid, noteId: noteId, collectionName: fromCollection);
    } catch (e) {
      print("transfer failed");
      print(e);
      Get.snackbar(
        "Transfer Operation failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<void> addNote(
      {required String uid, String collectionName = 'notes', required NoteModel note, String? noteId}) async {
    try {
      final data = {
        "title": note.title,
        "body": note.body,
        "dateCreated": note.dateCreated,
        "isFavourite": note.isFavourite
      };
      if (noteId == null) {
        _firestore.collection('users').doc(uid).collection(collectionName).add(data);
      } else {
        // To Preserve the noteID for easier integration when transferring notes between collections
        _firestore.collection('users').doc(uid).collection(collectionName).doc(noteId).set(data);
      }
    } catch (e) {
      print("add error");
      print(e);
      Get.snackbar(
        "Remove Operation failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<void> deleteNote({required String uid, String collectionName = 'trash', required String noteId}) async {
    try {
      _firestore.collection('users').doc(uid).collection(collectionName).doc(noteId).delete();
    } catch (e) {
      print("delete Error");
      print(e);
      Get.snackbar(
        "Remove Operation failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<void> updatePin({required String uid, required int newPin}) async {
    try {
      _firestore.collection('users').doc(uid).update({"archivesPin": newPin});
    } catch (e) {
      print(e);
      Get.snackbar(
        "Updating Archive Pin failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<void> updateUser({required UserModel currentUserData, required UserModel newUserData}) async {
    Map<String, dynamic> fieldsToUpdate = {};
    if (currentUserData.userData.name == newUserData.userData.name) {
      fieldsToUpdate['profileData.name'] = newUserData.userData.name;
    }
    if (currentUserData.userData.email == newUserData.userData.email) {
      fieldsToUpdate['profileData.email'] = newUserData.userData.email;
    }
    if (currentUserData.userData.profileUrl == newUserData.userData.profileUrl) {
      fieldsToUpdate['profileData.profileUrl'] = newUserData.userData.profileUrl;
    }
    if (currentUserData.archivesPin == newUserData.archivesPin) {
      fieldsToUpdate['archivesPin'] = newUserData.archivesPin;
    }
    try {
      _firestore.collection('users').doc(currentUserData.uid).update(fieldsToUpdate);
    } catch (e) {
      print("profile Update error");
      print(e);
      Get.snackbar(
        "Updating profile failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<void> updateArchivesPin({required String uid, required int pin}) async {
    try {
      _firestore.collection('users').doc(uid).update({"archivesPin": pin});
    } catch (e) {
      print('archivePin update error');
      print(e);
      Get.snackbar(
        "Updating pin failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }
}
