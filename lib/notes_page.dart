import 'package:flutter/material.dart';
import 'package:myapp/database_helper.dart';
import 'package:myapp/notes_edit_page.dart';
import 'package:intl/intl.dart';

import 'main.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    setState(() {
      _future = DatabaseHelper.fetchNotes(); // Fetch notes from SQLite database
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF202124),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white)));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No notes found.',
                    style: TextStyle(color: Colors.white)));
          }

          final notes = snapshot.data!;
          final colors = [
            0xFFE57373,
            0xFFFFF176,
            0xFF81C784,
            0xFF64B5F6,
            0xFFBA68C8
          ];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: notes.length,
              itemBuilder: (context, id) {
                final note = notes[id];
                final formattedDate = DateFormat('MM dd - HH:mm').format(note['created_at']);

                return NoteCard(
                  title: note['title'],
                  date: formattedDate,
                  color: Color(colors[id % colors.length]),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteEditPage()),
          );
          if (result != null && result) {
            _loadNotes(); // Refresh notes after adding a new one
          }
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
