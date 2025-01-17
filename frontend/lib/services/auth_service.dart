import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants.dart';

class AuthService {
  static final _storage = FlutterSecureStorage();

  // Login function
  static Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/token'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String token = data['access_token'];
      await _storage.write(key: 'auth_token', value: token);
    } else {
      throw Exception('Failed to login');
    }
  }

  // Sign-up function
  static Future<void> signUp(String name, String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String token = data['access_token'];
      await _storage.write(key: 'auth_token', value: token);
    } else if (response.statusCode == 400) {
      throw Exception('An account with this email already exists.');
    } else {
      throw Exception('Signup failed. Please try again.');
    }
  }

  // Logout function
  static Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  // Get token function
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Get current user ID function
  static Future<int?> getCurrentUserId() async {
    final token = await getToken();
    if (token == null) return null;

    final payload = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1]))));
    return payload['id'];
  }

  static Future<void> updatePassword(String currentPassword, String newPassword) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/auth/update_password'),  // Ensure this URL matches the backend
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['detail'] ?? 'Failed to update password');
    }
  }

  static Future<void> deleteAccount() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/auth/delete_account'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete account');
    }
  }
}