import 'package:flutter/material.dart';

class ProjectFAB extends StatelessWidget {
  final Function() onPressed;

  const ProjectFAB({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'addProject',
      backgroundColor: const Color(0xFF2196F3),
      onPressed: () => showAddProjectDialog(context),
      child: const Icon(Icons.add),
    );
  }

  void showAddProjectDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
    List<String> selectedTags = [];
    String visibility = 'private';

    final availableTags = [
      'Design',
      'Development',
      'Mobile',
      'Web',
      'Server',
      'Testing'
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242938),
        title: const Text(
          'Tambah Proyek Baru',
          style: TextStyle(color: Colors.white),
        ),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Nama Proyek',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Deskripsi Proyek',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.3)),
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
                    icon: const Icon(Icons.calendar_today,
                        color: Color(0xFF2196F3)),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Visibilitas',
                  style: TextStyle(color: Colors.white),
                ),
                Row(
                  children: [
                    Radio(
                      value: 'private',
                      groupValue: visibility,
                      onChanged: (value) =>
                          setState(() => visibility = value.toString()),
                    ),
                    const Text('Pribadi',
                        style: TextStyle(color: Colors.white)),
                    Radio(
                      value: 'public',
                      groupValue: visibility,
                      onChanged: (value) =>
                          setState(() => visibility = value.toString()),
                    ),
                    const Text('Publik', style: TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tag',
                  style: TextStyle(color: Colors.white),
                ),
                Wrap(
                  spacing: 8,
                  children: availableTags.map((tag) {
                    return FilterChip(
                      label: Text(tag),
                      selected: selectedTags.contains(tag),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedTags.add(tag);
                          } else {
                            selectedTags.remove(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                onPressed();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
