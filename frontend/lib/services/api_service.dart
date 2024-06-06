import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'auth_service.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class ApiService {
  static Future<String> predictImage(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      Response response = await Dio().post('$baseUrl/predict/', data: formData);

      if (response.statusCode == 200) {
        return response.data['predicted_class'];
      } else {
        throw Exception('Failed to get prediction');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  static Future<void> addMaterial(String base64Image, String details) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/materials'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'image': base64Image,
        'details': details,
      }),
    );

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['detail'] ?? 'Failed to add material');
    }
  }

  static Future<List<Map<String, dynamic>>> getMaterials() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/materials'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load materials');
    }

    List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => e as Map<String, dynamic>).toList();
  }

  static Future<Map<String, dynamic>> getMaterial(int materialId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/materials/$materialId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load material details');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<void> updateMaterial(int materialId, String details) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/materials/$materialId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'details': details,
      }),
    );

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['detail'] ?? 'Failed to update material');
    }
  }

  static Future<void> deleteMaterial(int materialId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/materials/$materialId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete material');
    }
  }
}
