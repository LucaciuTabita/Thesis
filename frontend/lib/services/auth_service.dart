import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String _baseUrl = 'http://192.168.0.122:8080';
  static final _storage = FlutterSecureStorage();

  // Login function
  static Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/token'),
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

  // Logout function
  static Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  // Get token function
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
