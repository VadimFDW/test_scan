// A screen that allows users to take a picture using a given camera.
import 'package:another_flushbar/flushbar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool loading = false;
  bool upSquare = true;

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
    return AbsorbPointer(
      absorbing: loading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Зробіть фото'),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() => upSquare = !upSquare);
                },
                icon: Icon(upSquare ? Icons.arrow_downward : Icons.arrow_upward))
          ],
        ),
        body: Center(
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return loading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        child: Stack(
                          children: [
                            CameraPreview(_controller),
                            Positioned(
                              bottom: upSquare ? null : 0,
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
            setState(() => loading = true);
            try {
              await _initializeControllerFuture;
              final image = await _controller.takePicture();

              int statusCode = await upload(File(image.path));
              showFlushbar(context, statusCode);
              setState(() => loading = false);
            } catch (e) {
              setState(() => loading = false);
            }
          },
          child: Icon(Icons.camera_alt),
        ),
      ),
    );
  }
}

showFlushbar(BuildContext context, int statusCode) {
  String text = '';
  Color color = Colors.blue;
  Icon icon = Icon(
    Icons.spa,
    size: 28.0,
    color: Colors.blue[300],
  );

  switch (statusCode) {
    case 200:
      text = 'Успішно $statusCode';
      color = Color(0xFF81C784);
      icon = Icon(
        Icons.done,
        size: 28.0,
        color: Colors.green[500],
      );
      break;
    case 500:
      text = 'Помилка $statusCode';
      color = Color(0xFFE57373);
      icon = Icon(
        Icons.error,
        size: 28.0,
        color: Colors.red[500],
      );
      break;
    default:
      text = 'Погане фото, відправте повторно $statusCode';
      color = Color(0xFFFFF176);
      icon = Icon(
        Icons.refresh,
        size: 28.0,
        color: Colors.yellow[500],
      );
  }

  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    message: text,
    icon: icon,
    duration: Duration(seconds: 3),
    leftBarIndicatorColor: color,
  )..show(context);
}

Future<int> upload(File imageFile) async {
  // open a bytestream
  var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  // get file length
  var length = await imageFile.length();

  // string to uri
  var uri = Uri.parse("http://demo-ph.test.planohero.com/");

  // create multipart request
  var request = new http.MultipartRequest("POST", uri);

  // multipart that takes file
  var multipartFile = new http.MultipartFile('image', stream, length, filename: basename(imageFile.path));

  // add file to multipart
  request.files.add(multipartFile);
  request.fields['secret'] =
      'FnP6ySLx1CbgIPw2HGUSmmPPkmW7cHYNpKXcIBoot1fZVx25y3VVk94a1LOWflVapSq7554ZRrDC7U1VhShGMvYxqjzBEzRv380dU9F5KG0Dz9ipMsqL712OVpvAxsdm';

  // send
  var response = await request.send();
  print(response.statusCode);

  // listen for response
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });

  return response.statusCode;
}
