// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class GroupFAB extends StatelessWidget {
  final Function() onPressed;

  const GroupFAB({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Memperbesar ukuran container
      width: 60, // Memperbesar ukuran container
      margin: const EdgeInsets.only(right: 8),
      child: FloatingActionButton(
        heroTag: 'addGroup',
        backgroundColor: const Color(0xFF1565C0),
        elevation: 4,
        highlightElevation: 8,
        onPressed: () => showAddGroupDialog(context),
        child: const Icon(
          Icons.group_add,
          size: 30, // Memperbesar ukuran icon
          color: Colors.white,
        ),
      ),
    );
  }

  void showAddGroupDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242938),
        title: const Text(
          'Create a New Group',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Name of Group',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                onPressed();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
