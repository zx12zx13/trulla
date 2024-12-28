// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'group-project-detail.dart';

// Model classes remain the same
class TeamMember {
  final String id;
  final String name;
  final String email;
  final String role;
  final Color avatarColor;

  TeamMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatarColor,
  });
}

class Project {
  final String id;
  final String title;
  final double progress;
  final DateTime deadline;

  Project({
    required this.id,
    required this.title,
    required this.progress,
    required this.deadline,
  });

  bool get isDeadlineNear {
    final daysUntilDeadline = deadline.difference(DateTime.now()).inDays;
    return daysUntilDeadline <= 1;
  }
}

class ShowTeamPage extends StatefulWidget {
  final Map<String, dynamic> teamData;

  const ShowTeamPage({
    super.key,
    required this.teamData,
  });

  @override
  State<ShowTeamPage> createState() => _ShowTeamPageState();
}

class _ShowTeamPageState extends State<ShowTeamPage>
    with SingleTickerProviderStateMixin {
  bool isTeamMembersExpanded = true;
  bool isPendingMembersExpanded = true;
  bool isThisWeekExpanded = true;
  bool isLastMonthExpanded = true;

  bool isProjectTab = true;
  late Map<String, dynamic> teamData;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Updated color scheme to match theme
  final Color primaryColor = const Color(0xFF4E6AF3);
  final Color backgroundColor = const Color(0xFF0A0E21);
  final Color surfaceColor = const Color(0xFF1D1F33);
  final Color accentColor = const Color(0xFF6C63FF);
  final Color textColor = const Color(0xFFFFFFFF);
  final Color secondaryTextColor = const Color(0xFFB0BEC5);

  void _handleRejectMember(TeamMember member) {
    setState(() {
      pendingMembers.removeWhere((m) => m.id == member.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${member.name} telah ditolak'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Functions for team management
  void _handleEditTeamName(String newName) {
    setState(() {
      teamData = {
        ...teamData,
        'name': newName,
      };
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nama tim berhasil diubah menjadi "$newName"'),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _handleInviteMember(String email) {
    // Add validation
    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Email tidak valid'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Undangan berhasil dikirim ke $email'),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _handleAcceptMember(TeamMember member) {
    setState(() {
      pendingMembers.removeWhere((m) => m.id == member.id);
      teamMembers.add(TeamMember(
        id: member.id,
        name: member.name,
        email: member.email,
        role: 'Member',
        avatarColor: member.avatarColor,
      ));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${member.name} telah bergabung dengan tim'),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Existing data
  final List<TeamMember> teamMembers = [
    TeamMember(
      id: '1',
      name: 'Andre',
      email: 'andre@mail.com',
      role: 'Admin',
      avatarColor: const Color(0xFF4E6AF3),
    ),
    TeamMember(
      id: '2',
      name: 'Sarah',
      email: 'sarah@mail.com',
      role: 'Member',
      avatarColor: const Color(0xFFFF5252),
    ),
    TeamMember(
      id: '3',
      name: 'Michael',
      email: 'michael@mail.com',
      role: 'Member',
      avatarColor: const Color(0xFF4CAF50),
    ),
    TeamMember(
      id: '4',
      name: 'Emily',
      email: 'emily@mail.com',
      role: 'Member',
      avatarColor: const Color(0xFFFFA726),
    ),
  ];

  final List<TeamMember> pendingMembers = [
    TeamMember(
      id: '5',
      name: 'David',
      email: 'david@mail.com',
      role: '',
      avatarColor: const Color(0xFF9C27B0),
    ),
    TeamMember(
      id: '6',
      name: 'Jessica',
      email: 'jessica@mail.com',
      role: '',
      avatarColor: const Color(0xFF00BCD4),
    ),
  ];

  final List<Project> thisWeekProjects = [
    Project(
      id: '1',
      title: 'Mobile App Development',
      progress: 0.75,
      deadline: DateTime.now().add(const Duration(days: 3)),
    ),
    Project(
      id: '2',
      title: 'Website Redesign',
      progress: 0.45,
      deadline: DateTime.now().add(const Duration(days: 5)),
    ),
    Project(
      id: '3',
      title: 'API Integration',
      progress: 0.90,
      deadline: DateTime.now().add(const Duration(days: 1)),
    ),
  ];

  final List<Project> lastMonthProjects = [
    Project(
      id: '4',
      title: 'UI/UX Research',
      progress: 1.0,
      deadline: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Project(
      id: '5',
      title: 'Database Migration',
      progress: 1.0,
      deadline: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    teamData = widget.teamData;
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: textColor,
                size: 24,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [primaryColor, accentColor],
            ).createShader(bounds),
            child: Text(
              'Detail Team',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        teamData['color'] ?? primaryColor,
                        (teamData['color'] ?? primaryColor).withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (teamData['color'] ?? primaryColor)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.groups_rounded,
                    color: textColor,
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
                          Text(
                            teamData['name'] ?? 'Trulla Team',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              // Show dialog to edit team name
                              final TextEditingController controller =
                                  TextEditingController(text: teamData['name']);
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  backgroundColor: surfaceColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Edit Nama Tim',
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextField(
                                          controller: controller,
                                          style: TextStyle(color: textColor),
                                          decoration: InputDecoration(
                                            hintText: 'Masukkan nama tim baru',
                                            hintStyle: TextStyle(
                                              color: textColor.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            _handleEditTeamName(
                                                controller.text);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Simpan'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: primaryColor.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                color: primaryColor,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: (teamData['color'] ?? primaryColor)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: (teamData['color'] ?? primaryColor)
                                .withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          teamData['type'] ?? 'Public',
                          style: TextStyle(
                            color: teamData['color'] ?? primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTeamStat(
                  Icons.people_outline_rounded,
                  '${teamData['memberCount'] ?? 3}/10',
                  'Member',
                ),
                _buildTeamStat(
                  Icons.folder_open_rounded,
                  '${teamData['projectCount'] ?? 2}',
                  'Project',
                ),
                _buildTeamStat(
                  Icons.pending_outlined,
                  '${pendingMembers.length}',
                  'Pending',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamStat(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildTab(Icons.folder_rounded, 'Project', true),
          const SizedBox(width: 12),
          _buildTab(Icons.people_rounded, 'Member', false),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String text, bool isProject) {
    final isSelected = isProjectTab == isProject;
    return GestureDetector(
      onTap: () => setState(() => isProjectTab = isProject),
      child: Container(
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
              size: 20,
              color: isSelected ? textColor : textColor.withOpacity(0.7),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? textColor : textColor.withOpacity(0.7),
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildTeamInfo(),
                      const SizedBox(height: 20),
                      _buildTabSelector(),
                      const SizedBox(height: 20),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isProjectTab
                            ? _buildProjectList()
                            : _buildMembersList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildProjectList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProjectSection('This week', thisWeekProjects),
          const SizedBox(height: 20),
          _buildProjectSection('Last Month', lastMonthProjects),
        ],
      ),
    );
  }

  Widget _buildProjectSection(String title, List<Project> projects) {
    final isExpanded =
        title == 'This week' ? isThisWeekExpanded : isLastMonthExpanded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (title == 'This week') {
                isThisWeekExpanded = !isThisWeekExpanded;
              } else {
                isLastMonthExpanded = !isLastMonthExpanded;
              }
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: AnimatedRotation(
                  turns: isExpanded ? 0 : 0.25,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: textColor.withOpacity(0.6),
                    size: 20,
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
              ...projects.map((project) => TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) => Transform.scale(
                      scale: value,
                      child: _buildProjectCard(project),
                    ),
                  )),
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

  Widget _buildProjectCard(Project project) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupProjectDetailPage(
              projectData: {
                'name': project.title,
                'type': 'Active Project',
                'color': primaryColor,
                'teamName': teamData['name'],
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [surfaceColor, surfaceColor.withOpacity(0.95)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: project.isDeadlineNear
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDeadlineInfo(project),
                  ],
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
                    Icons.edit_rounded,
                    color: primaryColor,
                    size: 20,
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
                        '${(project.progress * 100).toInt()}%',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
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
                      widthFactor: project.progress,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, accentColor],
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
          ],
        ),
      ),
    );
  }

  Widget _buildDeadlineInfo(Project project) {
    final daysRemaining = project.deadline.difference(DateTime.now()).inDays;
    final isUrgent = project.isDeadlineNear;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 14,
            color: isUrgent ? const Color(0xFFFF5252) : primaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            '$daysRemaining Days',
            style: TextStyle(
              color: isUrgent ? const Color(0xFFFF5252) : primaryColor,
              fontSize: 12,
              fontWeight: isUrgent ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInviteButton(),
          const SizedBox(height: 20),
          if (pendingMembers.isNotEmpty) ...[
            _buildMemberSection('Permintaan Bergabung', pendingMembers,
                isPending: true),
            const SizedBox(height: 20),
          ],
          _buildMemberSection('Member Tim', teamMembers),
        ],
      ),
    );
  }

  Widget _buildInviteButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [surfaceColor, surfaceColor.withOpacity(0.95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          final TextEditingController controller = TextEditingController();
          showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: surfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Undang Member',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controller,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Masukkan email Member',
                        hintStyle: TextStyle(
                          color: textColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _handleInviteMember(controller.text);
                        Navigator.pop(context);
                      },
                      child: const Text('Undang'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_rounded,
              color: primaryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Undang Member',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberSection(String title, List<TeamMember> members,
      {bool isPending = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (isPending) {
                isPendingMembersExpanded = !isPendingMembersExpanded;
              } else {
                isTeamMembersExpanded = !isTeamMembersExpanded;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: AnimatedRotation(
                    turns: (isPending
                            ? isPendingMembersExpanded
                            : isTeamMembersExpanded)
                        ? 0
                        : 0.25,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: textColor.withOpacity(0.6),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Column(
            children: [
              const SizedBox(height: 16),
              ...members.map((member) => TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) => Transform.scale(
                      scale: value,
                      child: _buildMemberCard(member, isPending),
                    ),
                  )),
            ],
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState:
              (isPending ? isPendingMembersExpanded : isTeamMembersExpanded)
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }

  Widget _buildMemberCard(TeamMember member, bool isPending) {
    Widget memberContent = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [surfaceColor, surfaceColor.withOpacity(0.95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  member.avatarColor,
                  member.avatarColor.withOpacity(0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: member.avatarColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                member.name[0].toUpperCase(),
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member.email,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (!isPending && member.role.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                member.role,
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );

    if (isPending) {
      return Dismissible(
        key: Key(member.id),
        background: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.green, Colors.greenAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Icon(Icons.check, color: Colors.white),
            ),
          ),
        ),
        secondaryBackground: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.red, Colors.redAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            _handleAcceptMember(member);
            return true;
          } else {
            _handleRejectMember(member);
            return true;
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: memberContent,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: memberContent,
    );
  }

  Widget _buildFAB() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupProjectDetailPage(
                projectData: {
                  'name': 'Project Baru',
                  'type': 'Project Aktif',
                  'color': primaryColor,
                  'teamName': teamData['name'],
                },
              ),
            ),
          );
        },
        backgroundColor: primaryColor,
        elevation: 8,
        child: Icon(
          Icons.add,
          size: 24,
          color: textColor,
        ),
      ),
    );
  }
}
