import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:turnstile_user/customWidget/customAppbar.dart';
import 'package:turnstile_user/customWidget/customButton.dart';
import 'package:turnstile_user/presentation/dashboardScreen.dart';
import 'package:turnstile_user/presentation/qrScanner.dart';
import 'package:http/http.dart' as http;
import '../globals.dart';

class TagIDScreen extends StatefulWidget {
  final String? tag_id;

  TagIDScreen({super.key,  this.tag_id});


  Future<void> postData(String tagId, String email, BuildContext context) async {
    final url = Uri.parse('http://54.163.33.217:8000/post_tagid/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tag_id': tagId,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, show success pop-up
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Data uploaded successfully."),
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
    } else {
      // If the server does not return a 200 OK response, show failure pop-up
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to upload data."),
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
  }

  @override
  State<TagIDScreen> createState() => _TagIDScreenState();
}

class _TagIDScreenState extends State<TagIDScreen> {
  late TextEditingController _tag_idController;

  @override
  void initState() {
    super.initState();
    _tag_idController = TextEditingController(text: widget.tag_id ?? '');
  }

  @override
  void dispose() {
    _tag_idController.dispose();
    super.dispose();
  }

  Future<void> _navigateAndScanQr(BuildContext context) async {
    final scannedData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QrScanner()),
    );

    if (scannedData != null) {
      setState(() {
        _tag_idController.text = scannedData;
        // print(_tag_idController.text.runtimeType);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'TAG-ID ENROLLMENT', actions: [

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
      ],),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: TextField(
                controller: _tag_idController,
                cursorColor: Colors.black,
                enabled: true, // Enable editing
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'TAG-ID',
                  labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                  prefixIcon: Icon(Icons.numbers),

                  contentPadding: EdgeInsets.only(top: 12, bottom: 12),
                ),
              ),
            ),
            SizedBox(height: 20),

            CustomButton(text: "QR", onPressed: (){_navigateAndScanQr(context);}),
            SizedBox(height: 10),

            CustomButton(text: "Submit",onPressed: () async {
              await widget.postData(_tag_idController.text, loggedInUserEmail, context);
            },),
          ],
        ),
      ),
    );
  }
}
