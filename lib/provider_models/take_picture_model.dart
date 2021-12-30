import 'package:camera/camera.dart';
import 'package:test_scan/provider_models/network.dart';

class TakePictureModel extends Network {
  final CameraDescription camera;
  TakePictureModel({required this.camera});
  bool loading = false;
  bool upSquare = true;

  void stopLoading() {
    loading = false;
    update();
  }

  void startLoading() {
    loading = true;
    update();
  }

  void upDownSquare() {
    upSquare = !upSquare;
    update();
  }
}
