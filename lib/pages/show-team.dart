import 'package:flutter/material.dart';

// Model untuk anggota tim
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

// Widget untuk section yang dapat di-collapse
class CollapsibleSection extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  const CollapsibleSection({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = true,
  });

  @override
  State<CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<CollapsibleSection>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeIn));
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _handleTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
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
                  duration: const Duration(milliseconds: 200),
                  turns: _isExpanded ? 0.0 : -0.25,
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
        AnimatedBuilder(
          animation: _controller.view,
          builder: (context, child) {
            return ClipRect(
              child: Align(
                heightFactor: _heightFactor.value,
                child: child,
              ),
            );
          },
          child: Column(
            children: [
              const SizedBox(height: 16),
              ...widget.children,
            ],
          ),
        ),
      ],
    );
  }
}

class ShowTeamPage extends StatefulWidget {
  const ShowTeamPage({super.key});

  @override
  State<ShowTeamPage> createState() => _ShowTeamPageState();
}

class _ShowTeamPageState extends State<ShowTeamPage> {
  bool isProjectTab = true;

  // Data dummy untuk anggota tim
  final List<TeamMember> teamMembers = [
    TeamMember(
      id: '1',
      name: 'Andre',
      email: 'andre.kurni@gmail.com',
      role: 'Admin',
      avatarColor: Colors.amber,
    ),
    TeamMember(
      id: '2',
      name: 'Marino',
      email: 'marino@gmail.com',
      role: 'Anggota',
      avatarColor: Colors.yellow,
    ),
    TeamMember(
      id: '3',
      name: 'Gunawan',
      email: 'gunawan@gmail.com',
      role: 'Anggota',
      avatarColor: Colors.orange,
    ),
  ];

  // Data dummy untuk permintaan masuk
  final List<TeamMember> pendingMembers = [
    TeamMember(
      id: '4',
      name: 'Impostor',
      email: 'sus@gmail.com',
      role: '',
      avatarColor: Colors.blue,
    ),
    TeamMember(
      id: '5',
      name: 'Maria',
      email: 'maria@gmail.com',
      role: '',
      avatarColor: Colors.purple,
    ),
  ];

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
                  if (isProjectTab)
                    _buildProjectList(context)
                  else
                    _buildMembersList(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add member/project
        },
        backgroundColor: const Color(0xFF2196F3),
        child: const Icon(Icons.add, color: Colors.white),
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
          const AddProjectButton(),
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
    return CollapsibleSection(
      title: title,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: item,
              ))
          .toList(),
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

  Widget _buildTabRow() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF242938),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isProjectTab = true),
              child: _buildTab(Icons.folder_rounded, 'Project', isProjectTab),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isProjectTab = false),
              child: _buildTab(Icons.people_rounded, 'Anggota', !isProjectTab),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (pendingMembers.isNotEmpty) ...[
          _buildMemberSection('Permintaan Masuk', pendingMembers,
              isPending: true),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ],
        _buildMemberSection('Anggota Team', teamMembers),
      ],
    );
  }

  Widget _buildMemberSection(String title, List<TeamMember> members,
      {bool isPending = false}) {
    return CollapsibleSection(
      title: title,
      children: members
          .map((member) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MemberListItem(
                  member: member,
                  isPending: isPending,
                  onTap: () {
                    // Navigate to member detail page
                    print('Navigate to ${member.name}\'s profile');
                  },
                ),
              ))
          .toList(),
    );
  }
}

class MemberListItem extends StatelessWidget {
  final TeamMember member;
  final bool isPending;
  final VoidCallback onTap;

  const MemberListItem({
    super.key,
    required this.member,
    this.isPending = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: member.avatarColor,
              radius: 20,
              child: Text(
                member.name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.email,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isPending)
              ElevatedButton(
                onPressed: () {
                  // Handle accept member
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Terima',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else if (member.role.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1E2D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  member.role,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
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
