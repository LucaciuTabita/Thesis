import 'dart:convert';
import 'dart:io' as io;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontendtabita/constants.dart';
import 'package:frontendtabita/services/api_service.dart';
import 'package:frontendtabita/services/auth_service.dart';
import 'package:frontendtabita/Screens/Login/login_screen.dart';

import '../Account/delete_account_dialog.dart';
import '../Account/modify_password_screen.dart';
import '../Camera/camera_screen.dart';
import '../Material/material_details_screen.dart';
import '../Material/modify_material_screen.dart';
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
      try {
        String base64Image = base64Encode(io.File(pickedFile.path).readAsBytesSync());
        String details = await ApiService.predictImage(io.File(pickedFile.path)); // Use AI to get details
        await ApiService.addMaterial(base64Image, details);
        fetchMaterials(); // Refresh list after successful upload
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload photo: $e'),
          ),
        );
      }
    }
  }

  void _showAccountMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Modify Password'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ModifyPasswordScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await AuthService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Account'),
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeleteAccountDialog();
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteMaterial(int materialId) async {
    try {
      await ApiService.deleteMaterial(materialId);
      fetchMaterials(); // Refresh the list after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete material: $e'),
        ),
      );
    }
  }

  Widget _buildMaterialItem(Map<String, dynamic> material) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(material['details']),
            subtitle: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  '$baseUrl/${material['file_path']}',
                  width: double.infinity,
                  height: 300, // Set fixed height
                  fit: BoxFit.cover, // Crop the image to fit within the specified height and width
                ),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MaterialDetailsScreen(materialId: material['id']),
                    ),
                  );
                },
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModifyMaterialScreen(
                            materialId: material['id'],
                            initialDetails: material['details'],
                          ),
                        ),
                      );
                      if (result == true) {
                        fetchMaterials(); // Refresh list after successful update
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Material'),
                            content: Text('Are you sure you want to delete this material?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _deleteMaterial(material['id']);
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        automaticallyImplyLeading: false, // Remove the back button
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _showAccountMenu(context),
          ),
        ],
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
              return _buildMaterialItem(material);
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
