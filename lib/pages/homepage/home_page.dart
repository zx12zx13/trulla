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

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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
      'description': 'Pengumpulan project akan berakhir dalam 3 hari',
      'date': '21 Nov 2024',
      'daysRemaining': 3,
    },
    {
      'type': 'invitation',
      'title': 'Undangan Tim Baru',
      'description': 'Anda diundang untuk bergabung dengan tim "UI/UX Design"',
      'team': 'UI/UX Design',
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    // Sort projects by deadline initially
    projectsData.sort((a, b) {
      final deadlineA = a['deadline'] as DateTime;
      final deadlineB = b['deadline'] as DateTime;
      return deadlineA.compareTo(deadlineB);
    });

    filteredProjects = List<Map<String, dynamic>>.from(projectsData);
  }

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
                  project['tags'].any((tag) => tag
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase())))
              .toList()
              .cast<Map<String, dynamic>>();

      switch (_selectedIndex) {
        case 1:
          results = results
              .where((project) => project['status'] == 'ongoing')
              .toList();
        case 2:
          results = results
              .where((project) => project['status'] == 'completed')
              .toList();
        case 3:
          results = results
              .where((project) => project['status'] == 'cancelled')
              .toList();
      }

      results.sort((a, b) {
        final deadlineA = a['deadline'] as DateTime;
        final deadlineB = b['deadline'] as DateTime;
        return deadlineA.compareTo(deadlineB);
      });

      filteredProjects = results;
    });
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = 'Selamat Pagi';
    } else if (hour < 15) {
      greeting = 'Selamat Siang';
    } else if (hour < 18) {
      greeting = 'Selamat Sore';
    } else {
      greeting = 'Selamat Malam';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              'Andre',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.waving_hand_rounded,
              color: Colors.amber[600],
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Mari selesaikan tugas hari ini!',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTabRow() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildTab('Semua', 0),
          _buildTab('Sedang Berjalan', 1),
          _buildTab('Selesai', 2),
          _buildTab('Dibatalkan', 3),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
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
          color: isSelected ? const Color(0xFF2196F3) : const Color(0xFF242938),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
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
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Cari proyek...',
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
          ),
          onChanged: _filterProjects,
        ),
      );
    }

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
        statusColor = Colors.blue;
        statusIcon = Icons.timer;
        break;
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    final daysUntilDeadline =
        project['deadline'].difference(DateTime.now()).inDays;
    final isNearDeadline = daysUntilDeadline <= 1;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF242938),
        borderRadius: BorderRadius.circular(16),
        border: isNearDeadline ? Border.all(color: Colors.red, width: 2) : null,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project['description'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  statusIcon,
                  color: statusColor,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: project['progress'],
                    backgroundColor: statusColor.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(project['progress'] * 100).toInt()}%',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Spacer(),
              Icon(
                Icons.calendar_today,
                size: 14,
                color:
                    isNearDeadline ? Colors.red : Colors.white.withOpacity(0.7),
              ),
              const SizedBox(width: 4),
              Text(
                '$daysUntilDeadline hari',
                style: TextStyle(
                  color: isNearDeadline
                      ? Colors.red
                      : Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight:
                      isNearDeadline ? FontWeight.bold : FontWeight.normal,
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
    );
  }

  void _showNotifications() {
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E2D),
      appBar: buildAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    _buildTabRow(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    ...filteredProjects
                        .map((project) => _buildProjectCard(project)),
                    if (filteredProjects.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Tidak ada proyek yang ditemukan',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    const QuoteFooter(),
                  ],
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
