import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _notes = [];
  List<Map<String, dynamic>> get notes => _notes;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch notes from Firestore
  Future<void> fetchNotes() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('notes').get();
      _notes = snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "title": doc["title"],
          "description": doc["description"],
        };
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching notes: $e");
    }
  }

  // Add new note
  Future<void> addNote(String title, String description) async {
    try {
      DocumentReference docRef = await _firestore.collection('notes').add({
        "title": title,
        "description": description,
      });
      _notes.add({
        "id": docRef.id,
        "title": title,
        "description": description,
      });
      notifyListeners();
    } catch (e) {
      print("Error adding note: $e");
    }
  }

  // Edit note
  Future<void> editNote(String id, String title, String description) async {
    try {
      await _firestore.collection('notes').doc(id).update({
        "title": title,
        "description": description,
      });

      int index = _notes.indexWhere((note) => note["id"] == id);
      if (index != -1) {
        _notes[index] = {"id": id, "title": title, "description": description};
        notifyListeners();
      }
    } catch (e) {
      print("Error editing note: $e");
    }
  }

  // Delete note
  Future<void> deleteNote(String id) async {
    try {
      await _firestore.collection('notes').doc(id).delete();
      _notes.removeWhere((note) => note["id"] == id);
      notifyListeners();
    } catch (e) {
      print("Error deleting note: $e");
    }
  }
}
