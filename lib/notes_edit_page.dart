
import 'package:flutter/material.dart';
import 'package:myapp/database_helper.dart';

class NoteEditPage extends StatefulWidget {
  const NoteEditPage({super.key});

  @override
  NoteEditPageState createState() => NoteEditPageState();
}

class NoteEditPageState extends State<NoteEditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> saveNote() async {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty && content.isEmpty) {
      return;
    }

    await DatabaseHelper.insertNote({
      'title': title,
      'content': content,
      'created_at': DateTime.now().toIso8601String(),
    });

    // ignore: use_build_context_synchronously
    Navigator.pop(context, true); // Return true when note is saved
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202124),
      appBar: AppBar(
        backgroundColor: const Color(0xFF202124),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              saveNote();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.save, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
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
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white, fontSize: 24),
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 24),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: SingleChildScrollView(
                child: TextField(
                  controller: _contentController,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: const InputDecoration(
                    hintText: 'Type something...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
