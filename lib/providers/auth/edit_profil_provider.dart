import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trulla/pages/opening/login_page.dart';
import 'package:trulla/service/api_service.dart';
import 'package:trulla/utils/api_response.dart';

class EditProfilProvider extends ChangeNotifier {
  bool isLoading = false;

  String name = '';
  String email = '';

  final ApiService _apiService = ApiService();

  Future<void> fetchProfil(BuildContext context) async {
    // from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    email = prefs.getString('email') ?? '';

    notifyListeners();
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('name');
    prefs.remove('email');

    if (context.mounted) {
      await _apiService.getRequest('/auth/logout', context);
    }

    if (context.mounted) {
      // Redirect to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Future<void> updateProfil({
    required String name,
    required String password,
    required BuildContext context,
    required String confirmPassword,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      ApiResponse response = await _apiService.postRequest(
          '/auth/user',
          {
            'name': name,
            'password': password,
            'password_confirmation': confirmPassword
          },
          context);

      if (response.statusCode == 200) {
        if (context.mounted) {
          // update shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('name', name);
        }
        onSuccess();
      } else {
        onError(response.data['message']);
      }
    } catch (e) {
      onError('An error occurred: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
