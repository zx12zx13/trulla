// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:trulla/model/project_model.dart';
import 'project-detail.dart';
import '../notification/notification.dart';
import '../../widget/fab1/project_fab.dart';
import 'package:provider/provider.dart';
import 'package:trulla/providers/navigation/project_provider.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  int _selectedIndex = 0;

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

  List<Project> filteredProjects = [];

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

    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().fetchProjects(context).then((_) {
        setState(() {
          filteredProjects = context.read<ProjectProvider>().projects;
        });
      });
    });
  }

  String getSelectedTabText() {
    switch (_selectedIndex) {
      case 0:
        return 'all';
      case 1:
        return 'ongoing';
      case 2:
        return 'completed';
      case 3:
        return 'cancelled';
      default:
        return 'all';
    }
  }

  // void _filterProjects(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       filteredProjects = List.from(context.read<ProjectProvider>().projects);
  //     } else {
  //       filteredProjects = context
  //           .read<ProjectProvider>()
  //           .projects
  //           .where((project) =>
  //               project.judul.toLowerCase().contains(query.toLowerCase()))
  //           .toList();
  //     }
  //     _sortProjectsByDeadline();
  //   });
  // }

  Widget _buildTabRow() {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildTab('All', 0, Icons.grid_view_rounded),
          _buildTab('On Going', 1, Icons.timer_outlined),
          _buildTab('Completed', 2, Icons.check_circle_outline_rounded),
          _buildTab('Canceled', 3, Icons.cancel_outlined),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index, IconData icon) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          context
              .read<ProjectProvider>()
              .filterProjects(_searchController.text, getSelectedTabText());
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [primaryColor, accentColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : surfaceColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
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
              context
                  .read<ProjectProvider>()
                  .filterProjects('', getSelectedTabText());
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
            onChanged: (string) => context
                .read<ProjectProvider>()
                .filterProjects(string, getSelectedTabText()),
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

  Widget _buildProjectItem(Project project) {
    int daysRemaining = project.deadline.difference(DateTime.now()).inDays;
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
                      projectData: {
                        'title': project.judul,
                        'color': primaryColor,
                        'progress': project.completedChecklists /
                            project.checklists.length,
                        'deadline': project.deadline,
                        'description': project.deskripsi,
                        'status': project.status,
                        'tasks': project.checklists
                            .map((checklist) => {
                                  'title': checklist.judul,
                                  'isCompleted': checklist.subChecklists
                                      .every((sub) => sub.completed == 1),
                                })
                            .toList(),
                      },
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
                          color: primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.1),
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
                                primaryColor,
                                primaryColor.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
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
                                project.judul,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
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
                              color: primaryColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: primaryColor,
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
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${(project.checklists.isEmpty ? 0 : project.completedChecklists / project.checklists.length * 100).toInt()}%',
                                style: TextStyle(
                                  color: primaryColor,
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
                                color: primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: project.checklists.isEmpty
                                  ? 0
                                  : project.completedChecklists /
                                      project.checklists.length,
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      primaryColor,
                                      primaryColor.withOpacity(0.8),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.3),
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
                                : primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isUrgent
                                  ? const Color(0xFFFF5252).withOpacity(0.2)
                                  : primaryColor.withOpacity(0.2),
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
                                    : primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$daysRemaining Days',
                                style: TextStyle(
                                  color: isUrgent
                                      ? const Color(0xFFFF5252)
                                      : primaryColor,
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
                              color: primaryColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.task_alt_rounded,
                                size: 16,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${project.completedChecklists}/${project.checklists.length} Tasks',
                                style: TextStyle(
                                  color: primaryColor,
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
        child: Consumer<ProjectProvider>(
          builder: (context, projectProvider, child) {
            var projects = projectProvider.filteredProjects;

            if (projectProvider.loading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            }

            return LayoutBuilder(
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
                              _buildTabRow(),
                              ...projects
                                  .map((project) => _buildProjectItem(project)),
                              if (projects.isEmpty)
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
            );
          },
        ),
      ),
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: ProjectFAB(),
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
