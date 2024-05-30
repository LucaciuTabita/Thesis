import 'package:flutter/material.dart';
import 'package:frontendtabita/services/api_service.dart';

class ModifyMaterialScreen extends StatefulWidget {
  final int materialId;
  final String initialDetails;

  ModifyMaterialScreen({required this.materialId, required this.initialDetails});

  @override
  _ModifyMaterialScreenState createState() => _ModifyMaterialScreenState();
}

class _ModifyMaterialScreenState extends State<ModifyMaterialScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _detailsController;

  @override
  void initState() {
    super.initState();
    _detailsController = TextEditingController(text: widget.initialDetails);
  }

  Future<void> _updateMaterial() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ApiService.updateMaterial(widget.materialId, _detailsController.text.trim());
        Navigator.pop(context, true); // Indicate that the update was successful
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update material: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify Material'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(labelText: 'Details'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter details';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _updateMaterial,
                child: const Text('Update Material'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}