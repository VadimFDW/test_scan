import 'package:another_flushbar/flushbar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:test_scan/untils/untils.dart';

import 'provider_models/take_picture_model.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TakePictureModel>(context, listen: false);

    return Consumer<TakePictureModel>(
      builder: (context, model, child) => AbsorbPointer(
        absorbing: provider.loading,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Зробіть фото'),
            actions: [
              IconButton(
                  onPressed: () {
                    provider.upDownSquare();
                  },
                  icon: Icon(provider.upSquare ? Icons.arrow_downward : Icons.arrow_upward))
            ],
          ),
          body: Center(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return provider.loading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          child: Stack(
                            children: [
                              CameraPreview(_controller),
                              Positioned(
                                bottom: provider.upSquare ? null : 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(border: Border.all(width: 4, color: Colors.white)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              provider.startLoading();
              try {
                await _initializeControllerFuture;
                final image = await _controller.takePicture();
                int statusCode = await provider.upload(File(image.path));
                showFlushbar(context, statusCode);
                provider.stopLoading();
              } catch (e) {
                provider.stopLoading();
              }
            },
            child: Icon(Icons.camera_alt),
          ),
        ),
      ),
    );
  }
}
