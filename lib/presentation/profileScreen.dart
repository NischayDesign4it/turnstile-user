import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:turnstile_user/presentation/dashboardScreen.dart';
import '../customWidget/customAppbar.dart';
import '../customWidget/customButton.dart';
import 'package:turnstile_user/globals.dart' as globals;
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController myCompanyIdController = TextEditingController();
  String selectedJobRole = 'role1';
  final List<String> jobRoleOptions = ['role1', 'role2'];
  final TextEditingController jobLocationController = TextEditingController();

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> workerRegister(
      BuildContext context, String name, String companyName, String jobRole, String myCompanyId, String jobLocation) async {
    final String apiUrl = 'http://44.214.230.69:8000/user_profile_api/';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'name': name,
          'company_name': companyName,
          'job_role': jobRole,
          'mycompany_id': myCompanyId,
          'job_location': jobLocation,
        },
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('Registration response: $responseData');

        // Check if the response indicates successful registration
        if (responseData == responseData) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Upload Successful'),
                content: Text('The details have been uploaded successfully.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Handle registration failure
          print('Registration failed. Message: ${responseData['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Incorrect details. Please try again.'),
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        // Handle other HTTP status codes
        print('Registration failed. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again later.'),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Error during registration: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred. Please try again later.',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'FILL YOUR DETAILS',
        // title: 'FILL YOUR DETAILS',
        actions: [
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

        ],
      ),
      body: SingleChildScrollView(
          child: Center(
          child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: widget.nameController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelText: 'Name',
                labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                prefixIcon: Icon(Icons.account_balance_rounded),
                contentPadding: EdgeInsets.only(top: 12, bottom: 12),
              ),
            ),
        SizedBox(height: 10),
        TextField(
          controller: widget.companyNameController,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.black),
            ),
            labelText: 'Company Name',
            labelStyle: TextStyle(fontSize: 20, color: Colors.black),
            prefixIcon: Icon(Icons.account_balance_rounded),
            contentPadding: EdgeInsets.only(top: 12, bottom: 12),
          ),
        ),
        SizedBox(height: 10),
        DropdownButtonFormField(
          value: widget.selectedJobRole,
          items: widget.jobRoleOptions.map((String role) {
            return DropdownMenuItem(
              value: role,
              child: Text(role),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              widget.selectedJobRole = value!;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.black),
            ),
            labelText: 'Job Role',
            labelStyle: TextStyle(fontSize: 20, color: Colors.black),
            prefixIcon: Icon(Icons.check_circle_outline),
            contentPadding: EdgeInsets.only(top: 12, bottom: 12),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: widget.myCompanyIdController,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.black),
            ),
            labelText: 'Company-ID',
            labelStyle: TextStyle(fontSize: 20, color: Colors.black),
            prefixIcon: Icon(Icons.tag),
            contentPadding: EdgeInsets.only(top: 12, bottom: 12),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: widget.jobLocationController,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.black),
            ),
            labelText: 'Location',
            labelStyle: TextStyle(fontSize: 20, color: Colors.black),
            prefixIcon: Icon(Icons.location_on),
            contentPadding: EdgeInsets.only(top: 12, bottom: 12),
          ),
        ),
        SizedBox(height: 20),

            CustomButton(text: 'Login', onPressed: (){
              workerRegister(
                context,
                widget.nameController.text,
                widget.companyNameController.text,
                widget.selectedJobRole,
                widget.myCompanyIdController.text,
                widget.jobLocationController.text,
              );

            }),
        ],
      ),
    ),
    ),
    ),
    );
  }
}
