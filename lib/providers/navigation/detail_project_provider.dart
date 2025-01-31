import 'package:flutter/material.dart';
import 'package:trulla/model/project_model.dart';
import 'package:trulla/service/api_service.dart';
import 'package:trulla/utils/api_response.dart';

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

  Future<ApiResponse> addChecklist(String judul, BuildContext context) async {
    if (_project == null) {
      return ApiResponse(statusCode: 400, data: {
        'message': 'Project not found',
      });
    }

    ApiResponse response = await _apiService.postRequest(
      '/project/add_checklist/${_project!.id}',
      {
        'judul': judul,
      },
      context,
    );

    print(response.data);

    if (response.statusCode == 201) {
      Checklist newChecklist = Checklist.fromJson(response.data['data']);
      _project!.checklists.add(newChecklist);
      notifyListeners();
    }

    return response;
  }

  Future<void> addSubChecklist(
      int id, String judul, BuildContext context) async {
    if (_project == null) {
      return;
    }

    ApiResponse response = await _apiService.postRequest(
      '/project/add_sub_checklist/$id',
      {
        'text': judul,
      },
      context,
    );

    print(response.data);

    if (response.statusCode == 201) {
      SubChecklist newSubChecklist =
          SubChecklist.fromJson(response.data['data']);
      _project!.checklists
          .firstWhere((checklist) => checklist.id == id)
          .subChecklists
          .add(newSubChecklist);
      notifyListeners();
    }
  }

  Future<bool> updateSubChecklist(
      int id, bool value, BuildContext context) async {
    if (_project == null) {
      return false;
    }

    ApiResponse response = await _apiService.postRequest(
        '/project/update_sub_checklist/$id', {'status': value}, context);

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }

  Future<void> updateDeadline(DateTime deadline, BuildContext context) async {
    if (_project == null) {
      return;
    }

    setLoading(true);

    ApiResponse response = await _apiService.postRequest(
        '/project/${_project!.id}/updateDeadline',
        {'deadline': deadline.toIso8601String()},
        context);

    setLoading(false);

    if (response.statusCode != 200) {
      return;
    }

    _project!.deadline = deadline;
    notifyListeners();
  }

  Future<void> updateDeskripsi(String deskripsi, BuildContext context) async {
    if (_project == null) {
      return;
    }
    setLoading(true);
    ApiResponse response = await _apiService.postRequest(
      '/project/${_project!.id}/updateDeskripsi',
      {
        'deskripsi': deskripsi,
      },
      context,
    );

    setLoading(false);

    if (response.statusCode != 200) {
      return;
    }

    _project!.deskripsi = deskripsi;
    notifyListeners();
  }

  Future<void> deleteChecklist(int id, BuildContext context) async {
    if (_project == null) {
      return;
    }
    setLoading(true);
    ApiResponse response =
        await _apiService.getRequest('/project/delete_checklist/$id', context);
    setLoading(false);

    if (response.statusCode != 200) {
      return;
    }

    _project!.checklists.removeWhere((checklist) => checklist.id == id);
    notifyListeners();
  }

  // update checklist
  Future<void> updateChecklist(
      int id, String judul, BuildContext context) async {
    if (_project == null) {
      return;
    }
    setLoading(true);
    ApiResponse response = await _apiService.postRequest(
      '/project/update_checklist/$id',
      {
        'judul': judul,
      },
      context,
    );
    setLoading(false);

    if (response.statusCode != 200) {
      return;
    }

    _project!.checklists.firstWhere((checklist) => checklist.id == id).judul =
        judul;
    notifyListeners();
  }
}
