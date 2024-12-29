// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'project-detail.dart';
import '../notification/notification.dart';
import '../../widget/fab1/project_fab.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Updated colors to match theme
  final Color primaryColor = const Color(0xFF4E6AF3);
  final Color backgroundColor = const Color(0xFF0A0E21);
  final Color surfaceColor = const Color(0xFF1D1F33);
  final Color accentColor = const Color(0xFF6C63FF);
  final Color textColor = const Color(0xFFFFFFFF);
  final Color secondaryTextColor = const Color(0xFFB0BEC5);

  List<Map<String, dynamic>> filteredProjects = [];

  // Your existing dummy data
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
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    filteredProjects = List.from(projects);
    _sortProjectsByDeadline();
    _animationController.forward();
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
      _sortProjectsByDeadline();
    });
  }

  AppBar buildAppBar() {
    if (_isSearching) {
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: textColor,
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
              _filterProjects('');
            });
          },
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'Cari project...',
              hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
              border: InputBorder.none,
              suffixIcon: Icon(
                Icons.search,
                color: textColor.withOpacity(0.5),
              ),
            ),
            onChanged: _filterProjects,
          ),
        ),
      );
    }

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: kToolbarHeight * 1.1,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: surfaceColor,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.apps_rounded, color: primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              'Trulla',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.search_rounded, size: 22),
          ),
          color: textColor,
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.notifications_none_rounded, size: 22),
          ),
          color: textColor,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: surfaceColor,
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.2),
                  accentColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activities',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [primaryColor, accentColor],
                  ).createShader(bounds),
                  child: const Text(
                    'Project',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: accentColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.task_alt_rounded,
                        color: accentColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Easily organize and manage projects',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectItem(Map<String, dynamic> project) {
    int daysRemaining = project['deadline'].difference(DateTime.now()).inDays;
    bool isUrgent = daysRemaining <= 1;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      surfaceColor,
                      surfaceColor.withOpacity(0.95),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: isUrgent
                      ? Border.all(color: const Color(0xFFFF5252), width: 2)
                      : Border.all(
                          color: project['color'].withOpacity(0.2),
                          width: 1,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: project['color'].withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                project['color'],
                                project['color'].withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: project['color'].withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.label_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project['title'],
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                project['type'],
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 14,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: project['color'].withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: project['color'],
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: TextStyle(
                                color: textColor.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: project['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${(project['progress'] * 100).toInt()}%',
                                style: TextStyle(
                                  color: project['color'],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Stack(
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: project['color'].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: project['progress'].toDouble(),
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      project['color'],
                                      project['color'].withOpacity(0.8),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: project['color'].withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isUrgent
                                ? const Color(0xFFFF5252).withOpacity(0.1)
                                : project['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isUrgent
                                  ? const Color(0xFFFF5252).withOpacity(0.2)
                                  : project['color'].withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 16,
                                color: isUrgent
                                    ? const Color(0xFFFF5252)
                                    : project['color'],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$daysRemaining Days',
                                style: TextStyle(
                                  color: isUrgent
                                      ? const Color(0xFFFF5252)
                                      : project['color'],
                                  fontSize: 13,
                                  fontWeight: isUrgent
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: project['color'].withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.task_alt_rounded,
                                size: 16,
                                color: project['color'],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${(project['tasks'] as List).where((task) => task['isCompleted'] == true).length}/${(project['tasks'] as List).length} Tasks',
                                style: TextStyle(
                                  color: project['color'],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (project['tags'] as List<String>).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                accentColor.withOpacity(0.2),
                                primaryColor.withOpacity(0.2),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: accentColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: textColor.withOpacity(0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: buildAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildHeader(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...filteredProjects
                              .map((project) => _buildProjectItem(project)),
                          if (filteredProjects.isEmpty)
                            Center(
                              child: Container(
                                margin: const EdgeInsets.all(30),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: accentColor.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      color: textColor.withOpacity(0.5),
                                      size: 48,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Tidak ada project yang ditemukan',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: textColor.withOpacity(0.7),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ProjectFAB(
          onPressed: () {
            // Project creation logic will be handled in ProjectFAB
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
