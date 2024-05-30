import 'package:flutter/material.dart';
import 'package:frontendtabita/services/api_service.dart';

import '../../constants.dart';

class MaterialDetailsScreen extends StatefulWidget {
  final int materialId;

  MaterialDetailsScreen({required this.materialId});

  @override
  _MaterialDetailsScreenState createState() => _MaterialDetailsScreenState();
}

class _MaterialDetailsScreenState extends State<MaterialDetailsScreen> {
  late Future<Map<String, dynamic>> _materialDetails;

  @override
  void initState() {
    super.initState();
    _materialDetails = ApiService.getMaterial(widget.materialId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _materialDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Material not found'));
          }

          final material = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Details: ${material['details']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Image.network('$baseUrl/${material['file_path']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
