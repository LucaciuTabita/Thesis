import 'package:flutter/material.dart';
import 'package:frontendtabita/services/api_service.dart';
import 'package:frontendtabita/services/auth_service.dart';
import 'package:frontendtabita/Screens/Login/login_screen.dart';

class DeleteAccountDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Account'),
      content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              await AuthService.deleteAccount();
              await AuthService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to delete account: $e'),
                ),
              );
              Navigator.of(context).pop(); // Close the dialog
            }
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
