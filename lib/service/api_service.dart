import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trulla/utils/api_response.dart';
import 'package:trulla/pages/opening/login_page.dart';

class ApiService {
  String baseUrl = "http://10.0.2.2:8000/api";

  Future<ApiResponse> getRequest(String endpoint, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response goten, ' + response.statusCode.toString());

    final decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 401) {
      prefs.remove('token');
      print('Token expired');
      if (context.mounted) {
        _redirectToLogin(context);
      }
    }
    return ApiResponse(
      statusCode: response.statusCode,
      data: jsonDecode(decodedResponse),
    );
  }

  Future<ApiResponse> postRequest(
    String endpoint,
    Map<String, dynamic> body,
    BuildContext context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    final decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 401) {
      prefs.remove('token');
      if (context.mounted) {
        _redirectToLogin(context);
      }
    }
    return ApiResponse(
      statusCode: response.statusCode,
      data: jsonDecode(decodedResponse),
    );
  }

  Future<ApiResponse> postRequestNoToken(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    final decodedResponse = utf8.decode(response.bodyBytes);
    return ApiResponse(
      statusCode: response.statusCode,
      data: jsonDecode(decodedResponse),
    );
  }

  void _redirectToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
