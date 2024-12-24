import 'package:flutter/material.dart';
import 'project-detail.dart';

class TagPage extends StatefulWidget {
  const TagPage({super.key});

  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  bool _isMyTeamExpanded = true;
  bool _isJoinedTeamExpanded = true;
  late AnimationController _fabController;
  late Animation<double> _fabScaleAnimation;

  List<Map<String, dynamic>> filteredMyTeams = [];
  List<Map<String, dynamic>> filteredJoinedTeams = [];

  final List<Map<String, dynamic>> myTeams = [
    {
      'name': 'Andre Project',
      'type': 'Development',
      'color': const Color(0xFF2196F3),
      'memberCount': 5,
      'projectCount': 3
    },
    {
      'name': 'UI/UX Team',
      'type': 'Design',
      'color': const Color(0xFF4CAF50),
      'memberCount': 4,
      'projectCount': 2
    },
  ];

  final List<Map<String, dynamic>> joinedTeams = [
    {
      'name': 'Backend Team',
      'type': 'Development',
      'color': const Color(0xFFFFC107),
      'memberCount': 6,
      'projectCount': 4
    },
    {
      'name': 'QA Team',
      'type': 'Testing',
      'color': const Color(0xFFE91E63),
      'memberCount': 3,
      'projectCount': 2
    },
  ];

  final List<Map<String, dynamic>> projects = [
    {
      'title': 'UI Design App',
      'progress': 0.8,
      'description': 'Mobile app UI design project',
      'dueDate': DateTime.now().add(Duration(days: 5))
    },
    {
      'title': 'Backend Development',
      'progress': 0.6,
      'description': 'Server development',
      'dueDate': DateTime.now().add(Duration(days: 10))
    },
    {
      'title': 'Mobile Development',
      'progress': 0.3,
      'description': 'Flutter mobile app',
      'dueDate': DateTime.now().add(Duration(days: 15))
    },
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
    filteredMyTeams = List.from(myTeams);
    filteredJoinedTeams = List.from(joinedTeams);

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );
  }

  void _filterTeams(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMyTeams = List.from(myTeams);
        filteredJoinedTeams = List.from(joinedTeams);
      } else {
        filteredMyTeams = myTeams
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
        filteredJoinedTeams = joinedTeams
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
            _showNotificationsSheet(context);
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
            _filterTeams('');
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
        onChanged: _filterTeams,
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
    Color color,
    BuildContext context,
    int memberCount,
    int projectCount,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          if (name == 'Andre Project') {
            // Menambahkan kondisi untuk "Andre Project"
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectDetailPage(
                  projectData: {
                    'name': name,
                    'type': type,
                    'color': color,
                    'memberCount': memberCount,
                    'projectCount': projectCount,
                  },
                ),
              ),
            );
          }
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
                      color: color,
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

  void _showCreateTagDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController typeController = TextEditingController();
    Color selectedColor = const Color(0xFF2196F3);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242938),
        title: const Text(
          'Buat Project Baru',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Nama Project',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2196F3)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: typeController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Tipe Project',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2196F3)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Color selection
            Wrap(
              spacing: 8,
              children: [
                _buildColorOption(const Color(0xFF2196F3), selectedColor,
                    (color) {
                  selectedColor = color;
                }),
                _buildColorOption(const Color(0xFF4CAF50), selectedColor,
                    (color) {
                  selectedColor = color;
                }),
                _buildColorOption(const Color(0xFFFFC107), selectedColor,
                    (color) {
                  selectedColor = color;
                }),
                _buildColorOption(const Color(0xFFE91E63), selectedColor,
                    (color) {
                  selectedColor = color;
                }),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  typeController.text.isNotEmpty) {
                final newTag = {
                  'name': nameController.text,
                  'type': typeController.text,
                  'color': selectedColor,
                  'memberCount': 0,
                  'projectCount': 0,
                };
                setState(() {
                  myTeams.add(newTag);
                  filteredMyTeams = List.from(myTeams);
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
            ),
            child: const Text('Buat'),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(
      Color color, Color selectedColor, Function(Color) onSelect) {
    return GestureDetector(
      onTap: () => onSelect(color),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: color == selectedColor ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF242938),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifikasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: notifications.length,
                itemBuilder: (context, index) =>
                    _buildNotificationItem(notifications[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    if (notification['type'] == 'deadline') {
      return _buildDeadlineNotification(notification);
    } else {
      return _buildInvitationNotification(notification);
    }
  }

  Widget _buildDeadlineNotification(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFF5252).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFF5252).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.timer_outlined,
              color: Color(0xFFFF5252),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      notification['date'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification['description'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(120, 32),
                      ),
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: const Text('Lihat Detail'),
                    ),
                    const Spacer(),
                    Text(
                      'Sisa: ${notification['daysRemaining']} hari',
                      style: const TextStyle(
                        color: Color(0xFFFF5252),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvitationNotification(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF2196F3),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['description'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(80, 32),
                      ),
                      child: const Text('Terima'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(80, 32),
                      ),
                      child: Text(
                        'Tolak',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
                  _buildTeamSection(
                    'Project Saya',
                    filteredMyTeams
                        .map((team) => _buildTeamItem(
                              team['name'],
                              team['type'],
                              team['color'],
                              context,
                              team['memberCount'],
                              team['projectCount'],
                            ))
                        .toList(),
                    _isMyTeamExpanded,
                    () =>
                        setState(() => _isMyTeamExpanded = !_isMyTeamExpanded),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  _buildTeamSection(
                    'Project Yang Diikuti',
                    filteredJoinedTeams
                        .map((team) => _buildTeamItem(
                              team['name'],
                              team['type'],
                              team['color'],
                              context,
                              team['memberCount'],
                              team['projectCount'],
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
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF2196F3),
          elevation: 4,
          onPressed: () => _showCreateTagDialog(context),
          child: const Icon(
            Icons.add_rounded,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabController.dispose();
    super.dispose();
  }
}
