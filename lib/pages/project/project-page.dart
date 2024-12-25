import 'package:flutter/material.dart';
import 'project-detail.dart';
import '../notification/notification.dart';
import '../../widget/fab1/project_fab.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> filteredProjects = [];

  final List<Map<String, dynamic>> projects = [
    {
      'title': 'UI Design App',
      'name': 'UI Design App',
      'type': 'Design',
      'color': const Color(0xFF2196F3),
      'progress': 0.8,
      'deadline': DateTime.now().add(const Duration(days: 5)),
      'description': 'Mobile app UI design project',
      'status': 'ongoing',
      'tags': ['Design', 'Mobile'],
      'tasks': [
        {'title': 'Design System', 'isCompleted': true},
        {'title': 'Wireframes', 'isCompleted': true},
        {'title': 'High-fidelity Design', 'isCompleted': false},
      ],
    },
    {
      'title': 'Backend Development',
      'name': 'Backend Development',
      'type': 'Development',
      'color': const Color(0xFF4CAF50),
      'progress': 1.0,
      'deadline': DateTime.now().add(const Duration(days: 7)),
      'description': 'Server development and API integration',
      'status': 'completed',
      'tags': ['Development', 'Server'],
      'tasks': [
        {'title': 'API Design', 'isCompleted': true},
        {'title': 'Database Setup', 'isCompleted': true},
        {'title': 'Server Configuration', 'isCompleted': true},
      ],
    },
    {
      'title': 'Mobile Development',
      'name': 'Mobile Development',
      'type': 'Development',
      'color': const Color(0xFFFFC107),
      'progress': 0.3,
      'deadline': DateTime.now().add(const Duration(days: 1)),
      'description': 'Flutter mobile app development',
      'status': 'ongoing',
      'tags': ['Development', 'Mobile'],
      'tasks': [
        {'title': 'Project Setup', 'isCompleted': true},
        {'title': 'Core Features', 'isCompleted': false},
        {'title': 'Testing', 'isCompleted': false},
      ],
    }
  ];

  final List<Map<String, dynamic>> notifications = [
    {
      'type': 'deadline',
      'title': 'Deadline Project',
      'description': 'Pengumpulan project akan berakhir dalam 3 hari',
      'date': '21 Nov 2024',
      'daysRemaining': 3,
    },
    {
      'type': 'deadline',
      'title': 'Deadline Project',
      'description': 'Review code harus selesai minggu ini',
      'date': '21 Nov 2024',
      'daysRemaining': 5,
    }
  ];

  @override
  void initState() {
    super.initState();
    filteredProjects = List.from(projects);
    _sortProjectsByDeadline();
  }

  void _sortProjectsByDeadline() {
    filteredProjects.sort((a, b) {
      DateTime deadlineA = a['deadline'];
      DateTime deadlineB = b['deadline'];
      return deadlineA.compareTo(deadlineB);
    });
  }

  void _filterProjects(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProjects = List.from(projects);
      } else {
        filteredProjects = projects
            .where((project) =>
                project['title']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                project['type']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                project['tags'].any((tag) =>
                    tag.toString().toLowerCase().contains(query.toLowerCase())))
            .toList();
      }
    });
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
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, size: 26),
          color: Colors.white,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: const Color(0xFF242938),
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => NotificationsSheet(
                notifications: notifications,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  AppBar _buildSearchBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () {
          setState(() {
            _isSearching = false;
            _searchController.clear();
            _filterProjects('');
          });
        },
      ),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Cari Project...',
          hintStyle: TextStyle(color: Colors.white60),
          border: InputBorder.none,
        ),
        onChanged: _filterProjects,
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aktifitas',
          style: TextStyle(
            color: Color(0xFFB0BEC5),
            fontSize: 16,
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Project',
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

  Widget _buildProjectItem(Map<String, dynamic> project) {
    int daysRemaining = project['deadline'].difference(DateTime.now()).inDays;
    bool isUrgent = daysRemaining <= 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailPage(
                projectData: project,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF242938),
            borderRadius: BorderRadius.circular(16),
            border: isUrgent ? Border.all(color: Colors.red, width: 2) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: project['color'],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.label_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          project['type'],
                          style: const TextStyle(
                            color: Color(0xFFB0BEC5),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1E2D),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF2196F3),
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${(project['progress'] * 100).toInt()}%',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: project['progress'],
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(project['color']),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: isUrgent ? Colors.red : const Color(0xFFB0BEC5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$daysRemaining hari',
                    style: TextStyle(
                      color: isUrgent ? Colors.red : const Color(0xFFB0BEC5),
                      fontSize: 12,
                      fontWeight:
                          isUrgent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (project['tags'] as List<String>)
                    .map((tag) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2196F3).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: Color(0xFF2196F3),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E2D),
      appBar: _isSearching ? _buildSearchBar() : buildAppBar(),
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
                  ...filteredProjects
                      .map((project) => _buildProjectItem(project)),
                  if (filteredProjects.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Tidak ada project yang ditemukan',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ProjectFAB(
          onPressed: () {
            setState(() {
              // Project creation logic will be handled in ProjectFAB
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
