// material_list.dart

import 'dart:io';

import 'package:flutter/material.dart';

class MaterialList extends StatelessWidget {
  final List<Map<String, dynamic>> materials;

  const MaterialList({Key? key, required this.materials}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: materials.length,
      itemBuilder: (context, index) {
        final material = materials[index];
        return ListTile(
          title: Text(material['details'] ?? 'No details'),
          leading: material['file_path'] != null
              ? Image.file(File(material['file_path']))
              : Icon(Icons.image),
        );
      },
    );
  }
}
