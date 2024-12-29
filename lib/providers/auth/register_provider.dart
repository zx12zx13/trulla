import 'package:flutter/material.dart';
import 'package:trulla/service/api_service.dart';
import 'package:trulla/utils/api_response.dart';

class RegisterProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _loading = false;

  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> register(
    String name,
    String email,
    String password, {
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    setLoading(true);
    try {
      ApiResponse response = await _apiService.postRequestNoToken(
        '/auth/register',
        {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        onSuccess();
      } else {
        onError('Failed to register: ${response.data['message']}');
      }
    } catch (e) {
      onError('An error occurred: $e');
    } finally {
      setLoading(false);
    }
  }
}
