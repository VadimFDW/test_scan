import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_scan/TakePictureScreen.dart';

import 'provider_models/take_picture_model.dart';

class StandPage extends StatelessWidget {
  const StandPage({
    Key? key,
    required this.title,
  }) : super(key: key);
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
              builder: (context) =>
                  TakePictureScreen(camera: Provider.of<TakePictureModel>(context, listen: false).camera),
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
