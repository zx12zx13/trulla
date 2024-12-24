import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
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
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGreeting(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      _buildTabRow(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      _buildProjectsList(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: kToolbarHeight * 1.1,
      title: Row(
        children: [
          Container(
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
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, size: 26),
          color: Colors.white,
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, size: 26),
          color: Colors.white,
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selamat Pagi',
          style: TextStyle(
            color: Color(0xFFB0BEC5),
            fontSize: 16,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Andre',
          style: TextStyle(
            color: Colors.white.withOpacity(0.95),
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTabRow() {
    return Row(
      children: [
        _buildTabButton('Sekarang', 0),
        const SizedBox(width: 12),
        _buildTabButton('Besok', 1),
        const SizedBox(width: 12),
        _buildTabButton('Minggu', 2),
      ],
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2196F3) : const Color(0xFF242938),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2196F3).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _selectedIndex = index),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    index == 0
                        ? Icons.calendar_today
                        : index == 1
                            ? Icons.calendar_today_outlined
                            : Icons.calendar_month,
                    size: 18,
                    color: isSelected ? Colors.white : Colors.white54,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white54,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsList() {
    return Column(
      children: [
        const ProjectCard(
          title: 'UI Design App',
          progress: 0.8,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        const ProjectCard(
          title: 'Backend Development',
          progress: 0.6,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        const ProjectCard(
          title: 'Mobile Development',
          progress: 0.3,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        const QuoteCard(),
      ],
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final double progress;

  const ProjectCard({
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.edit,
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

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Text(
            '"Setiap orang bisa mencuri ilmu, tapi tidak semua orang dapat mencuri Tindakmu"',
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Nadiem Makarim',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
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
