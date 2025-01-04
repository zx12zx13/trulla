import 'package:flutter/material.dart';
import 'package:trulla/model/project_model.dart';
import 'package:trulla/service/api_service.dart';

class DetailProjectProvider extends ChangeNotifier {
  bool isLoading = false;
  final ApiService _apiService = ApiService();

  Project? _project;
  Project? get project => _project;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> fetchProject(int id, BuildContext context) async {
    setLoading(true);
    // Fetch projects from API
    final fetchedProjects =
        await _apiService.getRequest('/project/$id', context);
    // Convert the fetched data to Project model
    if (fetchedProjects.data['data'] is Map) {
      final data = fetchedProjects.data['data'] as Map<String, dynamic>;
      final project = Project.fromJson(data);
      _project = project;
    } else {
      _project = null;
    }
    setLoading(false);
  }

  Future<bool> updateSubChecklist(
      int id, bool value, BuildContext context) async {
    if (_project == null) {
      return false;
    }

    await _apiService.postRequest(
        '/project/update_sub_checklist/$id', {'status': value}, context);
    return true;
  }
}
