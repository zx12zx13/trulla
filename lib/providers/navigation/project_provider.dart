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

  Future<void> fetchProjects(BuildContext context) async {
    setLoading(true);
    // Fetch projects from API
    final fetchedProjects = await _apiService.getRequest('/projects', context);
    // Convert the fetched data to Project model
    final data = fetchedProjects.data as List;
    _projects = data.map((i) => Project.fromJson(i)).toList();
    setLoading(false);
  }
}
