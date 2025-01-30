import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _notes = [];
  List<Map<String, dynamic>> get notes => _notes;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch notes from Firestore
  Future<void> fetchNotes() async {
    final user = _auth.currentUser;
    if (user != null) {
      final querySnapshot = await _firestore
          .collection('notes')
          .where('userId', isEqualTo: user.uid)
          .get();

      _notes = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'description': doc['description'],
        };
      }).toList();
      notifyListeners();
    }
  }

  // Add new note
  Future<void> addNote(Map<String, dynamic> noteData) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('notes').add({
        'userId': user.uid, // Store notes associated with the user's UID
        'title': noteData['title'],
        'description': noteData['description'],
        'createdAt': Timestamp.now(),
      });
      fetchNotes(); // Refresh the notes after adding
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
