// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trulla/providers/navigation/detail_project_provider.dart';

class UpdateCheckboxFAB extends StatefulWidget {
  const UpdateCheckboxFAB({
    super.key,
    required this.checklistId,
  });

  final int checklistId;

  @override
  State<UpdateCheckboxFAB> createState() => _UpdateCheckboxFABState();
}

class _UpdateCheckboxFABState extends State<UpdateCheckboxFAB> {
  final judulController = TextEditingController();

  Future<void> updateChecklist() async {
    final judul = judulController.text.trim();

    print('Updating: $judul');

    if (judul.isNotEmpty) {
      await context.read<DetailProjectProvider>().updateChecklist(
            widget.checklistId,
            judul,
            context,
          );

      if (context.mounted && mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Menyamakan ukuran container
      width: 60, // Menyamakan ukuran container
      margin: const EdgeInsets.only(right: 8),
      child: FloatingActionButton(
        heroTag: 'updateChecklist',
        backgroundColor: const Color(0xFF2196F3),
        elevation: 4,
        highlightElevation: 8,
        onPressed: () => showUpdateCheckboxDialog(context),
        child: const Icon(
          Icons.edit,
          size: 30, // Menyamakan ukuran icon
          color: Colors.white,
        ),
      ),
    );
  }

  void showUpdateCheckboxDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<DetailProjectProvider>(
          builder: (context, provider, child) {
            final checklist = provider.project?.checklists
                .firstWhere((checklist) => checklist.id == widget.checklistId);

            judulController.text = checklist?.judul ?? '';
            return AlertDialog(
              backgroundColor: const Color(0xFF242938),
              title: const Text(
                'Update Checklist',
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
                            hintText: 'Update list name',
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
                  onPressed: updateChecklist,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                  ),
                  child: provider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
