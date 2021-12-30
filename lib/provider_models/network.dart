import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Network extends ChangeNotifier {
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

  void update() => notifyListeners();
}
