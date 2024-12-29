import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FaceMaskDetectionScreen(),
  ));
}

class FaceMaskDetectionScreen extends StatefulWidget {
  @override
  _FaceMaskDetectionScreenState createState() =>
      _FaceMaskDetectionScreenState();
}

class _FaceMaskDetectionScreenState extends State<FaceMaskDetectionScreen> {
  File? _image;
  String _prediction = '';

  final picker = ImagePicker();

  // Pick an image
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      sendImageToServer(_image!);
    }
  }

  // Send image to Flask server for prediction
  Future sendImageToServer(File image) async {
    var uri = Uri.parse('http://127.0.0.1:5000/predict'); // Flask server URL
    var request = http.MultipartRequest('POST', uri);

    var pic = await http.MultipartFile.fromPath('image', image.path);
    request.files.add(pic);

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var prediction = jsonDecode(responseData);
      setState(() {
        _prediction = prediction['prediction'];
      });
    } else {
      setState(() {
        _prediction = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Face Mask Detection')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null) ...[
              Image.file(_image!),
              SizedBox(height: 20),
              Text(
                'Prediction: $_prediction',
                style: TextStyle(fontSize: 20),
              ),
            ],
            ElevatedButton(
              onPressed: getImage,
              child: Text('Take a Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
