import 'package:flutter/material.dart';
import 'package:frontendtabita/constants.dart';

class CameraButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CameraButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kPrimaryLightColor,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.camera_alt, size: 30),
        color: kPrimaryColor,
      ),
    );
  }
}