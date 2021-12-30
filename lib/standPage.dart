import 'package:another_flushbar/flushbar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:test_scan/TakePictureScreen.dart';

class StandPage extends StatelessWidget {
  const StandPage({
    Key? key,
    required this.camera,
    required this.title,
  }) : super(key: key);
  final CameraDescription camera;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TakePictureScreen(
                camera: camera,
              ),
            ),
          );
        },
        child: const Icon(Icons.camera_alt),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 220,
            // color: Colors.indigo,
            child: Image.asset("assets/stand.jpeg"),
          )
        ],
      ),
    );
  }
}
