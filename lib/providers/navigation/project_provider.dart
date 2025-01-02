import 'package:flutter/material.dart';
import 'package:trulla/model/project_model.dart';
import 'package:trulla/service/api_service.dart';

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
}
