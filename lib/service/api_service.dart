import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trulla/utils/api_response.dart';

class ApiService {
  String baseUrl = "http://10.0.2.2:8000/api";

  Future<ApiResponse> getRequest(String endpoint) async {
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

    final decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 401) {
      prefs.remove('token');
    }
    return ApiResponse(
      statusCode: response.statusCode,
      data: jsonDecode(decodedResponse),
    );
  }

  Future<ApiResponse> postRequest(
    String endpoint,
    Map<String, dynamic> body,
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
    }
    return ApiResponse(
      statusCode: response.statusCode,
      data: jsonDecode(decodedResponse),
    );
  }

  Future<ApiResponse> postRequestNoToken(
      String endpoint, Map<String, dynamic> body) async {
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
}
