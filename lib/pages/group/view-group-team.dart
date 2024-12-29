// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'show-team.dart';
import '../../widget/fab1/group_fab.dart';

class ListTeamPage extends StatefulWidget {
  const ListTeamPage({super.key});

  @override
  State<ListTeamPage> createState() => _ListTeamPageState();
}

class _ListTeamPageState extends State<ListTeamPage>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Updated color scheme to match theme
  final Color primaryColor = const Color(0xFF4E6AF3);
  final Color backgroundColor = const Color(0xFF0A0E21);
  final Color surfaceColor = const Color(0xFF1D1F33);
  final Color accentColor = const Color(0xFF6C63FF);
  final Color textColor = const Color(0xFFFFFFFF);
  final Color secondaryTextColor = const Color(0xFFB0BEC5);

  List<Map<String, dynamic>> filteredTeams = [];

  // Keeping original dummy data
  final List<Map<String, dynamic>> myTeams = [
    {
      'name': 'UI/UX Design Team',
      'type': 'Public',
      'color': const Color(0xFF2196F3),
      'memberCount': 5,
      'projectCount': 3,
      'members': [
        {'name': 'Sarah', 'email': 'sarah@example.com', 'role': 'Admin'},
        {'name': 'Michael', 'email': 'michael@example.com', 'role': 'Member'},
      ],
      'projects': [
        {
          'title': 'Website Redesign',
          'progress': 0.8,
          'createdAt': DateTime.now(),
        },
        {
          'title': 'Mobile App UI',
          'progress': 0.6,
          'createdAt': DateTime.now().subtract(const Duration(days: 7)),
        },
      ],
    },
    {
      'name': 'Frontend Team',
      'type': 'Public',
      'color': Colors.green,
      'memberCount': 8,
      'projectCount': 4,
      'members': [
        {'name': 'John', 'email': 'john@example.com', 'role': 'Admin'},
      ],
      'projects': [
        {
          'title': 'Dashboard Development',
          'progress': 0.4,
          'createdAt': DateTime.now().subtract(const Duration(days: 3)),
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> joinedTeams = [
    {
      'name': 'Backend Team',
      'type': 'Public',
      'color': Colors.orange,
      'memberCount': 12,
      'projectCount': 6,
      'members': [
        {'name': 'David', 'email': 'david@example.com', 'role': 'Admin'},
        {'name': 'Emma', 'email': 'emma@example.com', 'role': 'Member'},
      ],
      'projects': [
        {
          'title': 'API Development',
          'progress': 0.3,
          'createdAt': DateTime.now().subtract(const Duration(days: 30)),
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> notifications = [
    {
      'type': 'deadline',
      'title': 'Deadline Project',
      'description': 'Project submission deadline in 3 days',
      'date': '21 Nov 2024',
      'daysRemaining': 3,
    },
    {
      'type': 'invitation',
      'title': 'New Team Invitation',
      'description': 'You have been invited to join "Backend Team"',
      'team': 'Backend Team',
    },
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

    filteredTeams = List.from(myTeams);
    _animationController.forward();
  }

  void _filterTeams(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTeams = List.from(myTeams);
      } else {
        filteredTeams = myTeams
            .where((team) =>
                team['name']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                team['type']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
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
              _filterTeams('');
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
              hintText: 'Cari tim...',
              hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
              border: InputBorder.none,
              suffixIcon: Icon(
                Icons.search,
                color: textColor.withOpacity(0.5),
              ),
            ),
            onChanged: _filterTeams,
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
            // Notification handling
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
            padding: const EdgeInsets.all(20),
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
                  'Group',
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
                    'Team',
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
                        Icons.people_alt_rounded,
                        color: accentColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Manage teams and collaboration easily',
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

  Widget _buildTeamItem(Map<String, dynamic> team) {
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
                    builder: (context) => ShowTeamPage(teamData: team),
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
                  border: Border.all(
                    color: team['color'].withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: team['color'].withOpacity(0.1),
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
                                team['color'],
                                team['color'].withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: team['color'].withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
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
                              Text(
                                team['name'],
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                team['type'],
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
                              color: team['color'].withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: team['color'],
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: team['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: team['color'].withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.people_outline_rounded,
                                size: 16,
                                color: team['color'],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${team['memberCount']} Member',
                                style: TextStyle(
                                  color: team['color'],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
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
                              color: team['color'].withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.folder_outlined,
                                size: 16,
                                color: team['color'],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${team['projectCount']} Project',
                                style: TextStyle(
                                  color: team['color'],
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
                    if (team['projects'] != null &&
                        (team['projects'] as List).isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: team['color'].withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Projects',
                              style: TextStyle(
                                color: textColor.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...(team['projects'] as List)
                                .take(2)
                                .map((project) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: team['color'],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        project['title'],
                                        style: TextStyle(
                                          color: textColor.withOpacity(0.8),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: team['color'].withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${(project['progress'] * 100).toInt()}%',
                                        style: TextStyle(
                                          color: team['color'],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
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
        child: FadeTransition(
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
                      ...filteredTeams.map((team) => _buildTeamItem(team)),
                      if (filteredTeams.isEmpty)
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
                                  'Tidak ada tim yang ditemukan',
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
                SizedBox(height: MediaQuery.of(context).padding.bottom + 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: GroupFAB(onPressed: () {
          setState(() {});
        }),
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
