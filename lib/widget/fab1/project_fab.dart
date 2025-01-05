// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trulla/providers/navigation/project_provider.dart';

class ProjectFAB extends StatefulWidget {
  const ProjectFAB({
    super.key,
  });

  @override
  State<ProjectFAB> createState() => _ProjectFABState();
}

class _ProjectFABState extends State<ProjectFAB> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void addProject() {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();

    if (name.isNotEmpty && description.isNotEmpty) {
      context.read<ProjectProvider>().createProject(
            judul: name,
            deskripsi: description,
            deadline: selectedDate,
            context: context,
            onSuccess: () {},
            onError: (message) {},
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
        onPressed: () => showAddProjectDialog(context),
        child: const Icon(
          Icons.add,
          size: 30, // Menyamakan ukuran icon
          color: Colors.white,
        ),
      ),
    );
  }

  void showAddProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<ProjectProvider>(
          builder: (context, provider, child) {
            return AlertDialog(
              backgroundColor: const Color(0xFF242938),
              title: const Text(
                'Add a New Project',
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
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Name of Project',
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.6)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.3)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: descriptionController,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Description',
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.6)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.3)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Deadline',
                          style: TextStyle(color: Colors.white),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.calendar_today,
                              color: Color(0xFF2196F3),
                            ),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (picked != null) {
                                setState(() => selectedDate = picked);
                              }
                            },
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
                  onPressed: addProject,
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
