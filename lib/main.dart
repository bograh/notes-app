import 'package:flutter/material.dart';
import 'package:myapp/database_helper.dart';
import 'package:myapp/notes_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper.getDatabase(); // Initialize SQLite database
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF202124),
      ),
      home: const NotesPage(),
    );
  }
}

class NoteCard extends StatelessWidget {
  final String title;
  final String date;
  final Color color;

  const NoteCard({
    super.key,
    required this.title,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
