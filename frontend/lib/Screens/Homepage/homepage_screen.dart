import 'dart:convert';
import 'dart:io' as io;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/api_service.dart';
import '../Camera/camera_screen.dart';
import 'components/camera_button.dart';


class HomepageScreen extends StatefulWidget {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  List<dynamic> materials = [];

  @override
  void initState() {
    super.initState();
    fetchMaterials();
  }

  Future<void> fetchMaterials() async {
    final fetchedMaterials = await ApiService.getMaterials();
    setState(() {
      materials = fetchedMaterials;
    });
  }

  Future<void> _uploadPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String base64Image = base64Encode(io.File(pickedFile.path).readAsBytesSync());
      await ApiService.addMaterial(base64Image, 'Sample details');
      fetchMaterials(); // Refresh list after successful upload
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
      ),
      body: Stack(
        children: [
          // Background images
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              width: 120,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/images/login_bottom.png", width: 120),
          ),
          // HomePageScreen content
          ListView.builder(
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final material = materials[index];
              return ListTile(
                title: Text(material['details']),
                subtitle: Image.network('http://192.168.0.122:8080/${material['file_path']}'),
              );
            },
          ),
        ],
      ),
      floatingActionButton: CameraButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Choose an option'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      GestureDetector(
                        child: const Text("Take a photo"),
                        onTap: () async {
                          Navigator.of(context).pop();
                          final cameras = await availableCameras();
                          final firstCamera = cameras.first;
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CameraScreen(camera: firstCamera),
                            ),
                          );
                          if (result == true) {
                            fetchMaterials(); // Refresh list after successful upload
                          }
                        },
                      ),
                      Padding(padding: EdgeInsets.all(8.0)),
                      GestureDetector(
                        child: const Text("Upload a photo"),
                        onTap: () async {
                          Navigator.of(context).pop();
                          _uploadPhoto(); // Upload photo from device
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
