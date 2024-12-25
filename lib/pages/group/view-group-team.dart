import 'package:flutter/material.dart';
import 'show-team.dart';
import '../notification/notification.dart';
import '../../widget/fab1/group_fab.dart';
import '../../widget/fab1/project_fab.dart';

class ListTeamPage extends StatefulWidget {
  const ListTeamPage({super.key});

  @override
  State<ListTeamPage> createState() => _ListTeamPageState();
}

class _ListTeamPageState extends State<ListTeamPage> {
  bool _isMyTeamExpanded = true;
  bool _isJoinedTeamExpanded = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Updated dummy data - all teams are public
  final List<Map<String, dynamic>> myTeams = [
    {
      'name': 'UI/UX Design Team',
      'type': 'Publik',
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
      'type': 'Publik',
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
      'type': 'Publik',
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
                  _buildTeamSection(
                    'Tim Saya',
                    myTeams
                        .map((team) => _buildTeamItem(
                              team['name'],
                              team['type'],
                              team['color'],
                              context,
                              team['memberCount'],
                              team['projectCount'],
                              team,
                            ))
                        .toList(),
                    _isMyTeamExpanded,
                    () =>
                        setState(() => _isMyTeamExpanded = !_isMyTeamExpanded),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  _buildTeamSection(
                    'Tim Yang Diikuti',
                    joinedTeams
                        .map((team) => _buildTeamItem(
                              team['name'],
                              team['type'],
                              team['color'],
                              context,
                              team['memberCount'],
                              team['projectCount'],
                              team,
                            ))
                        .toList(),
                    _isJoinedTeamExpanded,
                    () => setState(
                        () => _isJoinedTeamExpanded = !_isJoinedTeamExpanded),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GroupFAB(onPressed: () {
            setState(() {});
          }),
          const SizedBox(height: 8),
          ProjectFAB(onPressed: () {
            setState(() {});
          }),
        ],
      ),
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
          });
        },
      ),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Cari tim...',
          hintStyle: TextStyle(color: Colors.white60),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {});
        },
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

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Grup',
          style: TextStyle(
            color: Color(0xFFB0BEC5),
            fontSize: 16,
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Team',
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

  Widget _buildTeamSection(
    String title,
    List<Widget> items,
    bool isExpanded,
    VoidCallback onToggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Row(
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
                child: AnimatedRotation(
                  turns: isExpanded ? 0 : -0.25,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white.withOpacity(0.6),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedCrossFade(
          firstChild: Column(
            children: [
              const SizedBox(height: 16),
              ...items,
            ],
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState:
              isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }

  Widget _buildTeamItem(
    String name,
    String type,
    Color iconColor,
    BuildContext context,
    int memberCount,
    int projectCount,
    Map<String, dynamic> teamData,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowTeamPage(teamData: teamData),
            ),
          );
        },
        child: Container(
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
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.groups_rounded,
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
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          type,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTeamStat(Icons.person_outline, '$memberCount Anggota'),
                  _buildTeamStat(Icons.folder_outlined, '$projectCount Proyek'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFFB0BEC5),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFFB0BEC5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
