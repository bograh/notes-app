import 'package:flutter/material.dart';
import 'package:myapp/database_helper.dart';
import 'package:myapp/notes_add_page.dart';
import 'package:myapp/note_content_page.dart';
import 'package:intl/intl.dart';

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
      _future = DatabaseHelper.fetchNotes();
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
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No notes found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final notes = snapshot.data!;
          final colors = [
            0xFFE57373,
            0xFFFFF176,
            0xFF81C784,
            0xFF64B5F6,
            0xFFBA68C8,
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
                String dateString = note['created_at'];
                DateTime createdAt = DateTime.parse(dateString);
                String formattedDate = DateFormat('MMMM dd, HH:mma').format(createdAt);

                return NoteCard(
                  id: note['id'],
                  title: note['title'],
                  date: formattedDate,
                  content: note['content'],
                  color: Color(colors[id % colors.length]),
                  reloadNotes: _loadNotes,
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
            MaterialPageRoute(builder: (context) => const NoteAddPage()),
          );
          if (result != null && result) {
            _loadNotes();
          }
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final int id;
  final String title;
  final String date;
  final String content;
  final Color color;
  final VoidCallback reloadNotes;

  const NoteCard({
    super.key,
    required this.id,
    required this.title,
    required this.date,
    required this.content,
    required this.color,
    required this.reloadNotes,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteContentPage(
              id: id,
              title: title,
              content: content,
              date: date,
            ),
          ),
        );
        if (result != null && result) {
          reloadNotes();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              date,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
