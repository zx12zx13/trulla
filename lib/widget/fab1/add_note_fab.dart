import 'package:flutter/material.dart';
import 'package:trulla/pages/project/project-note.dart';

class AddNoteFAB extends StatefulWidget {
  const AddNoteFAB({super.key});

  @override
  State<AddNoteFAB> createState() => _AddNoteFABState();
}

class _AddNoteFABState extends State<AddNoteFAB> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Menyamakan ukuran container
      width: 60, // Menyamakan ukuran container
      margin: const EdgeInsets.only(bottom: 10),
      child: FloatingActionButton(
        heroTag: 'addNote',
        backgroundColor: const Color(0xFF2196F3),
        elevation: 4,
        highlightElevation: 8,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProjectNotePage(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 30, // Menyamakan ukuran icon
          color: Colors.white,
        ),
      ),
    );
  }
}
