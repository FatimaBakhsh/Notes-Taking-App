import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_provider.dart';
import '../viewmodel/note_provider.dart';
import 'add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch notes when screen loads
    Provider.of<NoteProvider>(context, listen: false).fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          Tooltip(
            message: "Logout", // Shows "Logout" when hovered or long-pressed
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await authProvider.logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
      body: noteProvider.notes.isEmpty
          ? Center(child: Text("No notes available"))
          : ListView.builder(
              itemCount: noteProvider.notes.length,
              itemBuilder: (context, index) {
                final note = noteProvider.notes[index];
                return Card(
                  child: ListTile(
                    title: Text(note["title"],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(note["description"]),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
