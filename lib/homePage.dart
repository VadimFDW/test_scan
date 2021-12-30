import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:test_scan/standPage.dart';

class HomePage extends StatelessWidget {
  HomePage({required this.camera});

  final CameraDescription camera;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Стенди'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StandPage(
                        camera: camera,
                        title: 'Стенд вино',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  child: Center(
                    child: Text(
                      'Стенд вино',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => StandPage(
              //           camera: camera,
              //           title: 'Стенд горілка',
              //         ),
              //       ),
              //     );
              //   },
              //   style: ElevatedButton.styleFrom(
              //     primary: Colors.indigo,
              //     elevation: 5,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: 45,
              //     child: Center(
              //       child: Text(
              //         'Стенд горілка',
              //         style: TextStyle(color: Colors.white),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
