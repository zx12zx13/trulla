import 'package:flutter/material.dart';
import 'project_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePageContent(),
    ProjectListPage(),
    Center(
      child: Text(
        'Settings Page',
        style: TextStyle(color: Colors.white),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Trulla',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.search, color: Colors.white)),
          IconButton(
              onPressed: () {}, icon: Icon(Icons.notifications_sharp, color: Colors.white)),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9), // Transparan
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // Latar belakang transparan
          elevation: 0,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white54,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.home, _currentIndex == 0),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.check, _currentIndex == 1),
              label: 'Project',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.group, _currentIndex == 2),
              label: 'Group',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.person, _currentIndex == 2),
              label: 'Profil',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                // Aksi jika floating button ditekan
              },
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  // Membuat icon navbar dengan efek lingkaran transparan di sekelilingnya
  Widget _buildNavIcon(IconData icon, bool isActive) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue.withOpacity(0.2) : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: isActive ? Colors.blue : Colors.white54),
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Pagi 👋\nAndre',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildChip('Sekarang', Colors.blue, Colors.white),
                _buildChip('Besok', Colors.grey[800]!, Colors.white54),
                _buildChip('Minggu', Colors.grey[800]!, Colors.white54),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text(
                  'Judul Project',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '8/10 Selesai',
                  style: TextStyle(color: Colors.white54),
                ),
                trailing: Icon(Icons.edit, color: Colors.white54),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                '“Setiap orang bisa mencuri Idemu, \ntapi tidak semua orang dapat mencuri Tindakanmu.”',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Nadiem Makarim',
                style: TextStyle(
                    color: Colors.white54, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color bgColor, Color textColor) {
    return Chip(
      backgroundColor: bgColor,
      label: Text(
        label,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
