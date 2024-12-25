import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'group-project-note.dart';
import 'show-team.dart';

// Device-specific configurations
class DeviceInfo {
  final double width;
  final double height;
  final EdgeInsets padding;
  final double fontSize;
  final double iconSize;
  final double spacing;

  DeviceInfo({
    required this.width,
    required this.height,
    required this.padding,
    required this.fontSize,
    required this.iconSize,
    required this.spacing,
  });
}

class GroupProjectDetailPage extends StatefulWidget {
  final Map<String, dynamic> projectData;

  const GroupProjectDetailPage({
    super.key,
    required this.projectData,
  });

  @override
  State<GroupProjectDetailPage> createState() => _GroupProjectDetailPageState();
}

class _GroupProjectDetailPageState extends State<GroupProjectDetailPage> {
  int _selectedIndex = 0;
  final TextEditingController _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  double _progress = 0.0;
  String _detailText = '';
  final List<Map<String, dynamic>> _files = [];
  final List<Map<String, dynamic>> _tasks = [];
  bool isNewProject = false;

  @override
  void initState() {
    super.initState();
    isNewProject = widget.projectData['name'] == 'Project Baru';
    // Reset values for new project
    if (isNewProject) {
      _progress = 0.0;
      _descController.text = '';
    }
  }

  // Get device-specific configurations
  DeviceInfo _getDeviceInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // iPhone SE (2nd gen)
    if (size.width <= 375) {
      return DeviceInfo(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(12),
        fontSize: 14,
        iconSize: 20,
        spacing: 8,
      );
    }
    // iPhone 12/13/14
    else if (size.width <= 390) {
      return DeviceInfo(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(16),
        fontSize: 16,
        iconSize: 24,
        spacing: 12,
      );
    }
    // iPhone 12/13/14 Pro Max
    else if (size.width <= 428) {
      return DeviceInfo(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(20),
        fontSize: 18,
        iconSize: 28,
        spacing: 16,
      );
    }
    // Samsung Galaxy S21/S22
    else if (size.width <= 412) {
      return DeviceInfo(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(16),
        fontSize: 16,
        iconSize: 24,
        spacing: 12,
      );
    }
    // Default/Tablet
    else {
      return DeviceInfo(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(24),
        fontSize: 20,
        iconSize: 32,
        spacing: 20,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceInfo = _getDeviceInfo(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1E2D),
      body: Column(
        children: [
          // Fixed Header Section
          _buildHeader(deviceInfo),
          _buildProjectInfo(deviceInfo),
          _buildTabSelector(deviceInfo),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildDatePicker(deviceInfo),
                  _buildDescriptionField(deviceInfo),
                  Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding + 80),
                    child: _buildSelectedView(deviceInfo),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: SizedBox(
          height: deviceInfo.iconSize * 2,
          width: deviceInfo.iconSize * 2,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF2196F3),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GroupProjectNotePage(),
                ),
              );
            },
            child:
                Icon(Icons.add, color: Colors.white, size: deviceInfo.iconSize),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(DeviceInfo deviceInfo) {
    return Container(
      color: const Color(0xFF1A1E2D),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + deviceInfo.spacing,
        left: deviceInfo.padding.left,
        right: deviceInfo.padding.right,
        bottom: deviceInfo.padding.bottom,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: deviceInfo.iconSize,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                'Kembali',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: deviceInfo.fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowTeamPage(
                    teamData: {'name': 'Trulla Team'},
                  ),
                ),
              );
            },
            child: Text(
              'Simpan',
              style: TextStyle(
                color: const Color(0xFF2196F3),
                fontSize: deviceInfo.fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editProjectName() {
    final TextEditingController nameController =
        TextEditingController(text: widget.projectData['name']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242938),
        title: Text('Edit Nama Project di ${widget.projectData['teamName']}',
            style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Nama project',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.projectData['name'] = nameController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectInfo(DeviceInfo deviceInfo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: widget.projectData['color'],
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.projectData['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.projectData['type'],
                        style: const TextStyle(
                          color: Color(0xFFB0BEC5),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Colors.white.withOpacity(0.6),
                    size: 20,
                  ),
                  onPressed: _editProjectName,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(DeviceInfo deviceInfo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tenggat Waktu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _showDateTimePicker(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF242938),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd MMMM yyyy, HH:mm').format(_selectedDate),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Selesai',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField(DeviceInfo deviceInfo) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _descController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Tambahkan Deskripsi',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          filled: true,
          fillColor: const Color(0xFF242938),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        maxLines: 3,
      ),
    );
  }

  Widget _buildTabSelector(DeviceInfo deviceInfo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem(0, Icons.edit_note, 'Edit'),
          _buildTabItem(1, Icons.print_outlined, 'Cetak'),
          _buildTabItem(2, Icons.folder_outlined, 'File'),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isSelected ? const Color(0xFF2196F3) : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedView(DeviceInfo deviceInfo) {
    switch (_selectedIndex) {
      case 0:
        return SingleChildScrollView(
          child: _buildConfigurationView(),
        );
      case 1:
        return SingleChildScrollView(
          child: _buildDetailView(),
        );
      case 2:
        return SingleChildScrollView(
          child: _buildNotesView(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildConfigurationView() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF242938),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Konfigurasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!isNewProject)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: Colors.white, size: 20),
                        onPressed: () => _editConfiguration(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.white, size: 20),
                        onPressed: () => _deleteConfiguration(),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _progress / 100,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${_progress.toInt()}%',
              style: const TextStyle(
                color: Color(0xFF2196F3),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._tasks.map((task) => _buildTaskItem(task)).toList(),
            TextButton(
              onPressed: () => _addTask(),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text(
                '+ Tambah List',
                style: TextStyle(color: Color(0xFF2196F3)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTaskProgress() {
    if (_tasks.isEmpty) {
      _progress = 0.0;
      return;
    }
    int completedTasks = _tasks.where((task) => task['isCompleted']).length;
    _progress = (completedTasks / _tasks.length) * 100;
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          backgroundColor: const Color(0xFF242938),
          title: const Text('Tambah Task Baru',
              style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Nama task',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;
                setState(() {
                  _tasks.add({
                    'title': controller.text,
                    'isCompleted': false,
                  });
                  _updateTaskProgress();
                });
                Navigator.pop(context);
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _editDetail() {
    final TextEditingController controller =
        TextEditingController(text: _detailText);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242938),
        title: const Text('Edit Detail', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Detail aplikasi',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _detailText = controller.text;
                isNewProject = false;
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteDetail() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242938),
        title:
            const Text('Hapus Detail', style: TextStyle(color: Colors.white)),
        content: const Text('Yakin ingin menghapus detail?',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _detailText = '';
                isNewProject = true;
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _addFile() {
    final TextEditingController nameController = TextEditingController();
    String selectedType = 'PDF';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242938),
        title: const Text('Tambah File', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Nama file',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedType,
              dropdownColor: const Color(0xFF242938),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Tipe File',
                labelStyle: TextStyle(color: Colors.white),
              ),
              items: ['PDF', 'DOC', 'XLS'].map((String type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                selectedType = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              setState(() {
                _files.add({
                  'name': nameController.text,
                  'type': selectedType,
                });
                isNewProject = false;
              });
              Navigator.pop(context);
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _deleteFile(String fileName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242938),
        title: const Text('Hapus File', style: TextStyle(color: Colors.white)),
        content: Text('Yakin ingin menghapus $fileName?',
            style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _files.removeWhere((file) => file['name'] == fileName);
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _editConfiguration() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242938),
        title: const Text('Edit Konfigurasi',
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: _progress,
              onChanged: (value) {
                setState(() {
                  _progress = value;
                });
              },
              min: 0,
              max: 100,
              divisions: 100,
              label: '${_progress.toInt()}%',
            ),
            const Text('Progress', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailView() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF242938),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Detail Aplikasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: Colors.white, size: 20),
                      onPressed: () => _editDetail(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.white, size: 20),
                      onPressed: () => _deleteDetail(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _detailText.isEmpty ? 'Belum ada detail' : _detailText,
              style: TextStyle(
                color: _detailText.isEmpty ? Colors.white54 : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesView() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF242938),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Files',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  onPressed: () => _addFile(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFileList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Checkbox(
            value: task['isCompleted'],
            onChanged: (bool? value) {
              setState(() {
                task['isCompleted'] = value ?? false;
                _updateTaskProgress();
              });
            },
          ),
          Expanded(
            child: Text(
              task['title'],
              style: TextStyle(
                color: task['isCompleted'] ? Colors.grey : Colors.white,
                decoration: task['isCompleted']
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          IconButton(
            icon:
                const Icon(Icons.delete_outline, color: Colors.white, size: 20),
            onPressed: () {
              setState(() {
                _tasks.remove(task);
                _updateTaskProgress();
              });
            },
          ),
        ],
      ),
    );
  }

  void _deleteConfiguration() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242938),
        title: const Text('Hapus Konfigurasi',
            style: TextStyle(color: Colors.white)),
        content: const Text('Yakin ingin menghapus konfigurasi?',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _tasks.clear();
                _progress = 0.0;
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDateTimePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _selectedTime = pickedTime;
        });
      }
    }
  }

  Widget _buildFileList() {
    if (_files.isEmpty) {
      return const Text(
        'Belum ada file',
        style: TextStyle(color: Colors.white54),
      );
    }

    return Column(
      children: _files
          .map((file) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      file['type'] == 'PDF'
                          ? Icons.picture_as_pdf
                          : Icons.description,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        file['name'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.white, size: 20),
                      onPressed: () => _deleteFile(file['name']),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }
}
