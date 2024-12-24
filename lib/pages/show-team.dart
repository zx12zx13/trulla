import 'package:flutter/material.dart';

class ShowTeamPage extends StatelessWidget {
  const ShowTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E2D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: kToolbarHeight * 1.1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: Colors.white,
          iconSize: 26,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kembali',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TeamHeader(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  _buildTabRow(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  _buildProjectList(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabRow() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF242938),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTab(Icons.folder_rounded, 'Project', true)),
          Expanded(child: _buildTab(Icons.people_rounded, 'Anggota', false)),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2196F3) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : const Color(0xFF757575),
            size: 24,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF757575),
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProjectSection('Dibuka minggu ini', [
          const ProjectListItem(
            title: 'UI Design App',
            progress: 0.8,
          ),
          const ProjectListItem(
            title: 'Backend Development',
            progress: 0.6,
          ),
          AddProjectButton(),
        ]),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        _buildProjectSection('Dibuka bulan lalu', [
          const ProjectListItem(
            title: 'Mobile Development',
            progress: 0.3,
          ),
        ]),
      ],
    );
  }

  Widget _buildProjectSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFB0BEC5),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF242938),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white.withOpacity(0.6),
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items
            .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: item,
                ))
            .toList(),
      ],
    );
  }
}

class TeamHeader extends StatelessWidget {
  const TeamHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF242938),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2196F3).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Trulla Team',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.edit_rounded,
                      color: Colors.white.withOpacity(0.6),
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pribadi',
                  style: TextStyle(
                    color: Color(0xFFB0BEC5),
                    fontSize: 14,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStat('3/10', 'Anggota'),
                    const SizedBox(width: 20),
                    _buildStat('2', 'Permintaan Masuk'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Row(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFB0BEC5),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class ProjectListItem extends StatelessWidget {
  final String title;
  final double progress;

  const ProjectListItem({
    super.key,
    required this.title,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF242938),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1E2D),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Color(0xFF2196F3),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFF2196F3).withOpacity(0.2),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddProjectButton extends StatelessWidget {
  const AddProjectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF242938),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.add_circle_outline_rounded,
          color: const Color(0xFF2196F3).withOpacity(0.8),
          size: 32,
        ),
      ),
    );
  }
}
