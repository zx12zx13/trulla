import 'package:flutter/material.dart';

class ProjectListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Project-Mu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          _buildSectionTitle('Dibuka minggu ini'),
          _buildProjectCard('Judul Project', '8/10 Selesai'),
          _buildProjectCard('Judul Project', '8/10 Selesai'),
          const SizedBox(height: 20),
          _buildSectionTitle('Dibuka bulan lalu'),
          _buildProjectCard('Judul Project', '8/10 Selesai'),
          const SizedBox(height: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          // Aksi jika tombol tambah ditekan
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white54,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProjectCard(String title, String progress) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                progress,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white54),
            onPressed: () {
              // Aksi edit project
            },
          ),
        ],
      ),
    );
  }
}
