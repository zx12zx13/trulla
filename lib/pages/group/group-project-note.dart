import 'package:flutter/material.dart';
import 'show-team.dart';

class GroupProjectNotePage extends StatefulWidget {
  final Map<String, dynamic>? projectData;
  final String? existingNote;

  const GroupProjectNotePage({
    super.key,
    this.projectData,
    this.existingNote,
  });

  @override
  State<GroupProjectNotePage> createState() => _GroupProjectNotePageState();
}

class _GroupProjectNotePageState extends State<GroupProjectNotePage> {
  final TextEditingController _noteController = TextEditingController();
  bool _showAIOptions = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingNote != null) {
      _noteController.text = widget.existingNote!;
    }
  }

  void _handleSave() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ShowTeamPage(
          teamData: {'name': 'Trulla Team'},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E2D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF242938),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.file_present_outlined,
                color: Color(0xFF2196F3),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.projectData?['name'] ?? "New Note",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF242938),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Project Note',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.edit_outlined,
                  color: Colors.white.withOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _noteController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Write your note here...',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF242938),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1E2D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _showAIOptions = !_showAIOptions;
                          });
                        },
                        icon: Icon(
                          _showAIOptions
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_showAIOptions) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1E2D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AI Suggestions',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAIOption('Generate summary'),
                        _buildAIOption('Generate timeline'),
                        _buildAIOption('Generate tasks'),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildAIOption(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          // Handle AI option
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF2196F3).withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFF2196F3),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
