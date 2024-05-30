// display_picture_screen.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontendtabita/services/api_service.dart';
import 'package:frontendtabita/Screens/Homepage/homepage_screen.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display the Picture'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Image.file(File(imagePath)),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            child: FloatingActionButton(
              child: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: FloatingActionButton(
              child: const Icon(Icons.check),
              onPressed: () async {
                try {
                  String base64Image = base64Encode(File(imagePath).readAsBytesSync());
                  String details = await ApiService.predictImage(File(imagePath));
                  await ApiService.addMaterial(base64Image, details);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomepageScreen()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to add material: $e'),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}