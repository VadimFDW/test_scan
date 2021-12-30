import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_scan/HomePage.dart';

import 'provider_models/take_picture_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  runApp(ChangeNotifierProvider(
    create: (context) => TakePictureModel(camera: firstCamera),
    child: MaterialApp(
      theme: ThemeData.dark(),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}
