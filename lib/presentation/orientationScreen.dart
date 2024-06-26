import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../customWidget/customAppbar.dart';
import '../customWidget/customButton.dart';
import '../globals.dart';
import 'dashboardScreen.dart'; // Assuming this file contains the loggedInUserEmail variable

class OrientationScreen extends StatefulWidget {
  const OrientationScreen({Key? key}) : super(key: key);

  @override
  State<OrientationScreen> createState() => _OrientationScreenState();
}

class _OrientationScreenState extends State<OrientationScreen> {
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }

  Future<void> _uploadImages() async {
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://54.210.204.46:8000/mycomply_api/'),
    );
    request.fields['email'] = loggedInUserEmail;
    for (var image in _images) {
      request.files.add(await http.MultipartFile.fromPath(
        'my_comply',
        image.path,
      ));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        _images.clear();
        _isLoading = false;
      });
      _showDialog("Success", "Card are uploaded are uploaded successfully.");
      print('Images uploaded successfully');
    } else {
      setState(() {
        _isLoading = false;
      });
      _showDialog("Error", "Please upload the proper information.");
      print('Image upload failed');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _removeImage(int index) {
    print(loggedInUserEmail);
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'SST', actions: [
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.upload),
          onPressed:  _uploadImages,
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.dashboard),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen()),
            );
          },
        ),

      ], ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Image.file(
                            File(_images[index].path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            top: -13,
                            right: -13,
                            child: IconButton(
                              icon: Icon(Icons.cancel, color: Colors.white),
                              onPressed: () => _removeImage(index),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 18.0, left: 18.0, bottom: 30),
                child: CustomButton(text: "Capture you card", onPressed: _pickImage, icon: Icons.camera,),
              )
            ],
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
