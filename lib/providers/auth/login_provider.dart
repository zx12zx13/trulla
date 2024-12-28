import 'package:flutter/material.dart';
import 'package:trulla/service/api_service.dart';
import 'package:trulla/utils/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _loading = false;

  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> login(
    String email,
    String password,
    BuildContext context, {
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    setLoading(true);
    try {
      ApiResponse response = await _apiService.postRequestNoToken(
        '/auth/login',
        {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Save token to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = response.data['token'];
        prefs.setString('token', token);

        if (context.mounted) {
          ApiResponse userResponse =
              await _apiService.getRequest('/auth/user', context);
          if (userResponse.statusCode == 200) {
            // Save user data to shared preferences
            prefs.setString('name', userResponse.data['name']);
            prefs.setString('email', userResponse.data['email']);
            onSuccess();
          } else {
            onError('Failed to fetch user data');
          }
        }
      } else {
        onError('Login failed: ${response.data['message']}');
      }
    } catch (e) {
      onError('An error occurred: $e');
    } finally {
      setLoading(false);
    }
  }
}
