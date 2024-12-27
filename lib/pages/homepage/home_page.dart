// ignore_for_file: deprecated_member_use

import '../quotes/quotes.dart';
import '../notification/notification.dart';
import '../../widget/fab1/group_fab.dart';
import '../../widget/fab1/project_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Updated colors to match app theme
  final Color primaryColor = const Color(0xFF4E6AF3);
  final Color backgroundColor = const Color(0xFF0A0E21);
  final Color surfaceColor = const Color(0xFF1D1F33);
  final Color accentColor = const Color(0xFF6C63FF);
  final Color textColor = const Color(0xFFFFFFFF);
  final Color secondaryTextColor = const Color(0xFFB0BEC5);

  // Project data remains the same
  final List<Map<String, dynamic>> projectsData = [
    {
      'title': 'UI Design App',
      'progress': 0.8,
      'deadline': DateTime.now().add(const Duration(days: 5)),
      'description': 'Mobile app UI design project',
      'status': 'ongoing',
      'priority': 'high',
      'tags': ['Design', 'Mobile'],
    },
    {
      'title': 'Backend Development',
      'progress': 1.0,
      'deadline': DateTime.now().add(const Duration(days: 7)),
      'description': 'Server development and API integration',
      'status': 'completed',
      'priority': 'medium',
      'tags': ['Development', 'Server'],
    },
    {
      'title': 'Mobile Development',
      'progress': 0.3,
      'deadline': DateTime.now().add(const Duration(days: 10)),
      'description': 'Flutter mobile app development',
      'status': 'ongoing',
      'priority': 'high',
      'tags': ['Development', 'Mobile'],
    },
    {
      'title': 'Website Redesign',
      'progress': 0.0,
      'deadline': DateTime.now().add(const Duration(days: 15)),
      'description': 'Company website redesign project',
      'status': 'cancelled',
      'priority': 'low',
      'tags': ['Design', 'Web'],
    },
    {
      'title': 'Website Redesign',
      'progress': 0.7,
      'deadline': DateTime.now().add(const Duration(days: 2)),
      'description': 'Redesign company website with new brand guidelines',
      'status': 'ongoing',
      'tags': ['Design', 'Web', 'Frontend'],
    }
  ];

  List<Map<String, dynamic>> filteredProjects = [];

  final List<Map<String, dynamic>> notifications = [
    {
      'type': 'deadline',
      'title': 'Deadline Project',
      'description': 'Project collection will end in 3 days',
      'date': '21 Nov 2024',
      'daysRemaining': 3,
    },
    {
      'type': 'invitation',
      'title': 'New Team Invitation',
      'description': 'You are invited to join the “UI/UX Design” team',
      'team': 'UI/UX Design',
    },
    {
      'type': 'deadline',
      'title': 'Deadline Project',
      'description': 'Code review must be completed this week',
      'date': '21 Nov 2024',
      'daysRemaining': 5,
    }
  ];
  void _filterProjects(String query) {
    setState(() {
      List<Map<String, dynamic>> results = query.isEmpty
          ? List<Map<String, dynamic>>.from(projectsData)
          : projectsData
              .where((project) =>
                  project['title']
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  project['description']
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  (project['tags'] as List<String>).any((tag) => tag
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase())))
              .toList();

      // Filter based on selected tab
      switch (_selectedIndex) {
        case 1: // Ongoing
          results = results
              .where((project) => project['status'] == 'ongoing')
              .toList();
          break;
        case 2: // Completed
          results = results
              .where((project) => project['status'] == 'completed')
              .toList();
          break;
        case 3: // Cancelled
          results = results
              .where((project) => project['status'] == 'cancelled')
              .toList();
          break;
        default: // All projects
          break;
      }

      // Sort projects by deadline
      results.sort((a, b) {
        final deadlineA = a['deadline'] as DateTime;
        final deadlineB = b['deadline'] as DateTime;
        return deadlineA.compareTo(deadlineB);
      });

      filteredProjects = results;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

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

    projectsData.sort((a, b) {
      final deadlineA = a['deadline'] as DateTime;
      final deadlineB = b['deadline'] as DateTime;
      return deadlineA.compareTo(deadlineB);
    });

    filteredProjects = List<Map<String, dynamic>>.from(projectsData);
    _animationController.forward();
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 15) {
      greeting = 'Good Afternoon';
    } else if (hour < 18) {
      greeting = 'Good Evening';
    } else {
      greeting = 'Good Night';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [primaryColor, accentColor],
            ).createShader(bounds),
            child: Text(
              greeting,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Marino',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.waving_hand_rounded,
                  color: Colors.amber[600],
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  'Lets complete todays task!',
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
    );
  }

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
          _filterProjects(_searchController.text);
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
          color: Colors.white,
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
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Cari proyek...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              border: InputBorder.none,
              suffixIcon: Icon(
                Icons.search,
                color: Colors.white.withOpacity(0.5),
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
            const Text(
              'Trulla',
              style: TextStyle(
                color: Colors.white,
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
          color: Colors.white,
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
          color: Colors.white,
          onPressed: () => _showNotifications(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    Color statusColor;
    IconData statusIcon;

    switch (project['status']) {
      case 'ongoing':
        statusColor = primaryColor;
        statusIcon = Icons.timer;
        break;
      case 'completed':
        statusColor = const Color(0xFF4CAF50);
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
        statusColor = const Color(0xFFFF5252);
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    final daysUntilDeadline =
        project['deadline'].difference(DateTime.now()).inDays;
    final isNearDeadline = daysUntilDeadline <= 1;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 16),
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
              border: isNearDeadline
                  ? Border.all(color: const Color(0xFFFF5252), width: 2)
                  : Border.all(
                      color: statusColor.withOpacity(0.2),
                      width: 1,
                    ),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            project['description'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
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
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        statusIcon,
                        color: statusColor,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Progress',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${(project['progress'] * 100).toInt()}%',
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Stack(
                              children: [
                                Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: project['progress'].toDouble(),
                                  child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          statusColor,
                                          statusColor.withOpacity(0.8)
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 16,
                            color: isNearDeadline
                                ? const Color(0xFFFF5252)
                                : primaryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$daysUntilDeadline Days',
                            style: TextStyle(
                              color: isNearDeadline
                                  ? const Color(0xFFFF5252)
                                  : primaryColor,
                              fontSize: 13,
                              fontWeight: isNearDeadline
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.more_horiz,
                            color: accentColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (project['tags'] as List<String>)
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
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
                                color: Colors.white.withOpacity(0.9),
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
        );
      },
    );
  }

  void _showNotifications() {
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
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
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGreeting(),
                      _buildTabRow(),
                      ...filteredProjects
                          .map((project) => _buildProjectCard(project)),
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
                                  color: Colors.white.withOpacity(0.5),
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada proyek yang ditemukan',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const QuoteFooter(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GroupFAB(
              onPressed: () {
                setState(() {
                  // Group creation logic will be handled in GroupFAB
                });
              },
            ),
            const SizedBox(height: 10),
            ProjectFAB(
              onPressed: () {
                setState(() {
                  // Project creation logic will be handled in ProjectFAB
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
