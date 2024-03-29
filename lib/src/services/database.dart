import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/notes_controller.dart';
import 'package:notes_app/src/models/note_model.dart';
import 'package:notes_app/src/models/user.dart';
import 'package:notes_app/src/services/encrypter_class.dart';

class Database {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> createNewUser(UserModel user) async {
    try {
      // Create a new database model
      await _firestore.collection("users").doc(user.uid).set({
        "protectedSpacePin": user.protectedSpacePin,
        "uid": user.uid,
        "name": user.name,
        "iv": user.iv,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot _doc = await _firestore.collection("users").doc(uid).get();
      return UserModel.fromDocumentSnapshot(documentSnapshot: _doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future deleteUser(String uid) async {
    try {
      NotesController _notesController = Get.find<NotesController>();

      if (_notesController.notes != null && _notesController.notes!.isNotEmpty) {
        for (NoteModel note in _notesController.notes!) {
          Database.deleteNote(uid: uid, noteId: note.noteId!, collectionName: 'notes');
        }
      }

      if (_notesController.deletedNotes!.isNotEmpty) {
        for (NoteModel note in _notesController.deletedNotes!) {
          Database.deleteNote(uid: uid, noteId: note.noteId!);
        }
      }

      if (_notesController.lockedNotes!.isNotEmpty) {
        for (NoteModel note in _notesController.lockedNotes!) {
          Database.deleteNote(uid: uid, noteId: note.noteId!, collectionName: 'locked');
        }
      }
      await _firestore.collection("users").doc(uid).delete();
      print("delete Completed");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<void> updateName(String uid, String name) async {
    try {
      await _firestore.collection("users").doc(uid).update({"name": name});
    } catch (e) {
      print(e);
      Get.snackbar(
        "Updating name failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  static Future<void> updateProtectedSpacePin({required String uid, required String newPin}) async {
    try {
      await _firestore.collection('users').doc(uid).update({"protectedSpacePin": newPin});
    } catch (e) {
      print(e);
      Get.snackbar(
        "Updating Protected Space Pin failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  static Future<void> updateIV({required String uid, required String iv}) async {
    try {
      _firestore.collection('users').doc(uid).update({"iv": iv});
    } catch (e) {
      print(e);
      Get.snackbar(
        "Updating IV failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  static Stream<List<NoteModel>> noteStream({required String uid, String collectionName = 'notes'}) {
    List<NoteModel> getNotes(QuerySnapshot query) {
      List<NoteModel> retVal = [];
      query.docs.forEach((element) {
        if (collectionName == 'locked') {
          retVal.add(NoteModel.fromDocSnapshotEncrypted(element));
        } else {
          retVal.add(NoteModel.fromDocumentSnapshot(element));
        }
      });
      return retVal;
    }
    return _firestore
        .collection("users")
        .doc(uid)
        .collection(collectionName)
        .orderBy("dateCreated", descending: true)
        .snapshots()
        .map((QuerySnapshot query) => getNotes(query));

  
  }

  static Future<void> updateNote(
      {required String uid,
      required String collectionName,
      required NoteModel oldModel,
      required NoteModel newModel,
      bool? isForced}) async {
    try {
      Map<String, dynamic> updateFields = {};
      if (isForced != null && isForced) {
        updateFields['body'] = EncrypterClass.encryptText(string: newModel.body ?? "");
        updateFields['title'] = EncrypterClass.encryptText(string: newModel.title ?? "");
      } else {
        if (oldModel.body != newModel.body) {
          updateFields['body'] =
              collectionName == 'locked' ? EncrypterClass.encryptText(string: newModel.body ?? "") : newModel.body;
        }
        if (oldModel.title != newModel.title) {
          updateFields['title'] =
              collectionName == 'locked' ? EncrypterClass.encryptText(string: newModel.title ?? "") : newModel.title;
        }
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

  static Future<void> updateFavourite({required String uid, required String noteId, required bool isFavourite}) async {
    try {
      _firestore.collection('users').doc(uid).collection('notes').doc(noteId).update({"isFavourite": isFavourite});
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

  static Future<void> updateColor(
      {required String uid, required String noteId, required String color, String collectionName = 'notes'}) async {
    try {
      _firestore.collection('users').doc(uid).collection(collectionName).doc(noteId).update({"color": color});
    } catch (e) {
      print(e);
      Get.snackbar(
        "Updating the note color failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  static Future<void> transferNote(
      {required String uid,
      required String toCollection,
      required String fromCollection,
      required NoteModel noteModel}) async {
    try {
      addNote(uid: uid, collectionName: toCollection, note: noteModel);
      deleteNote(uid: uid, noteId: noteModel.noteId!, collectionName: fromCollection);
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

  static Future addNote({required String uid, String collectionName = 'notes', required NoteModel note}) async {
    try {
      final data = {
        "title": collectionName == "locked" ? EncrypterClass.encryptText(string: note.title ?? "") : note.title,
        "body": collectionName == "locked" ? EncrypterClass.encryptText(string: note.body ?? "") : note.body,
        "dateCreated": note.dateCreated,
        "isFavourite": note.isFavourite,
        "color": note.color,
      };
      if (note.noteId == null) {
        var noteResponse = await _firestore.collection('users').doc(uid).collection(collectionName).add(data);
        return noteResponse.id;
      } else {
        // To Preserve the noteID for easier integration when transferring notes between collections
        _firestore.collection('users').doc(uid).collection(collectionName).doc(note.noteId).set(data);
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

  static Future<void> deleteNote({required String uid, String collectionName = 'trash', required String noteId}) async {
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
}
