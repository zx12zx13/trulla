import 'package:flutter/material.dart';

class TagPage extends StatelessWidget {
  const TagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E2D),
      appBar: buildAppBar(),
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
                  _buildHeader(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  _buildProjectSection('Dibuka minggu ini'),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  _buildProjectSection('Dibuka bulan lalu'),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2196F3),
        elevation: 4,
        child: const Icon(Icons.add_rounded, size: 28),
        onPressed: () {},
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: kToolbarHeight * 1.1,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF242938),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.apps_rounded, color: Color(0xFF2196F3), size: 20),
            SizedBox(width: 8),
            Text(
              'Trulla',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, size: 26),
          color: Colors.white,
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, size: 26),
          color: Colors.white,
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daftar',
          style: TextStyle(
            color: Color(0xFFB0BEC5),
            fontSize: 16,
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Project-Mu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectSection(String title) {
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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            final projects = [
              {'title': 'UI Design App', 'progress': 0.8},
              {'title': 'Backend Development', 'progress': 0.6},
              {'title': 'Mobile Development', 'progress': 0.3},
            ];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ProjectCard(
                title: projects[index]['title'] as String,
                progress: projects[index]['progress'] as double,
              ),
            );
          },
        ),
      ],
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final double progress;

  const ProjectCard({
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
                  borderRadius: BorderRadius.circular(8),
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
