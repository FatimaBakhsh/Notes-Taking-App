import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _notes = [];

  List<Map<String, dynamic>> get notes => _notes;

  // Fetch notes from Firestore
  Future<void> fetchNotes() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('notes').get();
      _notes = snapshot.docs
          .map((doc) => {
                "id": doc.id,
                "title": doc["title"],
                "description": doc["description"],
              })
          .toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching notes: $e");
    }
  }

  // Add note to Firestore
  Future<void> addNote(String title, String description) async {
    try {
      await _firestore.collection('notes').add({
        "title": title,
        "description": description,
        "timestamp": FieldValue.serverTimestamp(),
      });
      fetchNotes(); // Refresh notes list
    } catch (e) {
      print("Error adding note: $e");
    }
  }
}
