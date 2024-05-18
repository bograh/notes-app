import 'package:flutter/material.dart';
import 'package:myapp/database_helper.dart';

class NoteContentPage extends StatelessWidget {
  final int id;
  final String title;
  final String content;
  final String date;

  const NoteContentPage({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  void _deleteNoteAndReturn(BuildContext context) async {
    await DatabaseHelper.deleteNoteById(id);
    // ignore: use_build_context_synchronously
    Navigator.pop(context, true); // Return true to indicate deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Note Content',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF202124),
        actions: [
          TextButton(
            onPressed: () {
              _deleteNoteAndReturn(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_forever, size: 32, color: Colors.red),
                SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: const TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
