// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trulla/providers/navigation/detail_project_provider.dart';
import 'package:trulla/providers/navigation/project_provider.dart';

class AddCheckboxFAB extends StatefulWidget {
  const AddCheckboxFAB({
    super.key,
  });

  @override
  State<AddCheckboxFAB> createState() => _AddCheckboxFABState();
}

class _AddCheckboxFABState extends State<AddCheckboxFAB> {
  final judulController = TextEditingController();

  void addChecklist() {
    final judul = judulController.text.trim();

    if (judul.isNotEmpty) {
      context.read<DetailProjectProvider>().addChecklist(
            judul,
            context,
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Menyamakan ukuran container
      width: 60, // Menyamakan ukuran container
      margin: const EdgeInsets.only(right: 8),
      child: FloatingActionButton(
        heroTag: 'addProject',
        backgroundColor: const Color(0xFF2196F3),
        elevation: 4,
        highlightElevation: 8,
        onPressed: () => showAddCheckboxDialog(context),
        child: const Icon(
          Icons.add,
          size: 30, // Menyamakan ukuran icon
          color: Colors.white,
        ),
      ),
    );
  }

  void showAddCheckboxDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<ProjectProvider>(
          builder: (context, provider, child) {
            return AlertDialog(
              backgroundColor: const Color(0xFF242938),
              title: const Text(
                'Add a Checklist',
                style: TextStyle(color: Colors.white),
              ),
              content: StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: judulController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Name a list',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.3)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  onPressed: addChecklist,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                  ),
                  child: provider.loading
                      ? const CircularProgressIndicator()
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
