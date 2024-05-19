import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontendtabita/models/material.dart';

class MaterialService {
  final String baseUrl = 'http://localhost:8000'; // Replace with your server address

  Future<List<Material>> getMaterials() async {
    final response = await http.get(Uri.parse('$baseUrl/materials'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Material.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load materials');
    }
  }

  Future<Material> createMaterial(Material material) async {
    final response = await http.post(
      Uri.parse('$baseUrl/materials'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(material.toJson()),
    );

    if (response.statusCode == 201) {
      return Material.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create material');
    }
  }

  // Implement other methods (getMaterial, updateMaterial, deleteMaterial) similarly
}