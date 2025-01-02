// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../pages/homepage/home_page.dart';
import '../pages/profile/profile.dart';
// import '../pages/group/view-group-team.dart';
import '../pages/project/project-page.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';

class NavBarController extends StatefulWidget {
  const NavBarController({super.key});

  @override
  State<NavBarController> createState() => _NavBarControllerState();
}

class _NavBarControllerState extends State<NavBarController> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // const HomePage(),
    const ProjectPage(),
    // const ListTeamPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CircleNavBar(
      activeIcons: const [
        // Icon(Icons.home_filled, color: Color(0xFF1A1A1A)),
        Icon(Icons.tag, color: Color(0xFF1A1A1A)),
        // Icon(Icons.groups, color: Color(0xFF1A1A1A)),
        Icon(Icons.person, color: Color(0xFF1A1A1A)),
      ],
      inactiveIcons: const [
        // Text(
        //   "Home",
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     color: Colors.white70,
        //   ),
        // ),
        Text(
          "Project",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        // Text(
        //   "Group",
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     color: Colors.white70,
        //   ),
        // ),
        Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
      ],
      color: const Color(0xFF2A2A2A),
      circleColor: const Color(0xFF2196F3),
      height: 60,
      circleWidth: 60,
      activeIndex: selectedIndex,
      onTap: onTap,
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 20,
      ),
      cornerRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(24),
        bottomLeft: Radius.circular(24),
      ),
      shadowColor: const Color(0xFF2196F3).withOpacity(0.3),
      circleShadowColor: const Color(0xFF2196F3).withOpacity(0.5),
      elevation: 10,
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          const Color(0xFF2A2A2A),
          Colors.black.withOpacity(0.8),
        ],
      ),
      circleGradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFF2196F3), // Primary blue
          Color(0xFF1976D2), // Slightly darker blue
        ],
      ),
    );
  }
}
