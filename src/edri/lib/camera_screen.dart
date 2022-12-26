import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraCamera(
        onFile: (file) {
          Navigator.pop(context, file);
        },
      ),
    );
  }
}
