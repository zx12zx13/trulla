import 'package:flutter/material.dart';
import 'package:trulla/model/project_model.dart';
import 'package:trulla/service/api_service.dart';
import 'package:trulla/utils/api_response.dart';

class ProjectProvider extends ChangeNotifier {
  bool _loading = false;
  final ApiService _apiService = ApiService();
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<Project> _projects = [];
  List<Project> get projects => _projects;

  List<Project> filteredProjects = [];

  Future<void> fetchProjects(BuildContext context) async {
    setLoading(true);
    // Fetch projects from API
    final fetchedProjects = await _apiService.getRequest('/project', context);
    // Convert the fetched data to Project model
    if (fetchedProjects.data['data'] is List) {
      final data = fetchedProjects.data['data'] as List<dynamic>;
      _projects =
          data.map((i) => Project.fromJson(i as Map<String, dynamic>)).toList();
    } else {
      _projects = [];
    }
    filteredProjects = List<Project>.from(_projects);
    print(filteredProjects);
    setLoading(false);
  }

  void filterProjects(String query, String status) {
    filteredProjects = _projects;

    if (query.isNotEmpty) {
      filteredProjects = _projects
          .where((project) =>
              project.judul.toLowerCase().contains(query.toLowerCase()) ||
              project.deskripsi.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    if (status != 'all') {
      filteredProjects =
          _projects.where((project) => project.status == status).toList();
    }

    filteredProjects.sort((a, b) {
      final deadlineA = a.deadline;
      final deadlineB = b.deadline;
      return deadlineA.compareTo(deadlineB);
    });

    notifyListeners();
  }

  Future<void> createProject({
    required String judul,
    required String deskripsi,
    required DateTime deadline,
    required BuildContext context,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      ApiResponse response = await _apiService.postRequest(
        '/project/store_private',
        {
          'judul': judul,
          'deskripsi': deskripsi,
          'deadline': deadline.toIso8601String(),
        },
        context,
      );

      if (response.statusCode == 201) {
        if (context.mounted) {
          await fetchProjects(context);
        }
        onSuccess();
      } else {
        onError('Failed to create project: ${response.data['message']}');
      }
    } catch (e) {
      onError('An error occurred: $e');
    }

    _loading = false;
    notifyListeners();
  }
}
