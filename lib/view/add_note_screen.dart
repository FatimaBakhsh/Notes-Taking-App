import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/note_provider.dart';

class AddNoteScreen extends StatefulWidget {
  final Map<String, dynamic>? note; // Optional note for editing

  const AddNoteScreen({Key? key, this.note}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      // Populate the fields if the note is being edited
      titleController.text = widget.note!["title"];
      descriptionController.text = widget.note!["description"];
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Note" : "Add Note")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();

                if (title.isNotEmpty && description.isNotEmpty) {
                  if (isEditing) {
                    // If editing, update the existing note
                    noteProvider.editNote(
                      widget.note!["id"],
                      title,
                      description,
                    );
                  } else {
                    // If adding, create a new note
                    noteProvider.addNote({
                      'title': title,
                      'description': description,
                    });
                  }
                  Navigator.pop(context); // Go back to the previous screen
                }
              },
              child: Text(isEditing ? "Update Note" : "Save Note"),
            ),
          ],
        ),
      ),
    );
  }
}
