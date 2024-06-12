import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:turnstile_user/customWidget/customButton.dart';
import 'package:turnstile_user/presentation/loginScreen.dart';
import '../customWidget/customAppbar.dart';
import '../globals.dart';
import 'dashboardScreen.dart';

class SignupScreen extends StatefulWidget {
   SignupScreen({super.key});


  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();


  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(
      BuildContext context, String name, String email, String password) async {
    final String apiUrl = 'http://54.210.204.46:8000/signupapi/';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );


      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('Login response: $responseData');

        // Check if the response indicates successful login
        if (responseData['message'] == 'Registration Successful') {
          loggedInUserName = name;
          // Navigate to the home screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          // Handle login failure
          print('Login failed. Message: ${responseData['message']}');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Incorrect Details. Please try again.'),
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
          nameController.clear();
          emailController.clear();
          passwordController.clear();
        }
      } else {
        // Handle other HTTP status codes
        print('Login failed. Status code: ${response.statusCode}');

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
      print('Error during login: $e');

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
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Create an Account', actions: [] ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Padding(
                //   padding: EdgeInsets.only(bottom: 30.0),
                //   child: Image.asset('assets/images/icon-light.png'),
                // ),
                // Text("Create an account", style: TextStyle(fontSize: 30)),
                // SizedBox(height: 20),

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
                    labelText: ("Name"),
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    prefixIcon: Icon(Icons.person),
                    contentPadding: EdgeInsets.only(top: 12, bottom: 12),

                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: widget.emailController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: ("Email"),
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    prefixIcon: Icon(Icons.email),
                    contentPadding: EdgeInsets.only(top: 12, bottom: 12),

                  ),
                ),

                SizedBox(height: 10),
                TextField(
                  controller: widget.passwordController,
                  cursorColor: Colors.black,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: Colors.black), // Border color when focused
                    ),
                    labelText: ("Password"),
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    prefixIcon: Icon(Icons.lock),
                    contentPadding: EdgeInsets.only(top: 12, bottom: 12),
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                    alignLabelWithHint: false,
                  ),
                ),
                SizedBox(height: 15),
                new GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => LoginPage()));
                  },
                  child: Text("Forgot Password?",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     widget.loginUser(
                //       context,
                //       widget.nameController.text,
                //
                //       widget.emailController.text,
                //       widget.passwordController.text,
                //     );
                //   }, child: Text("SIGNUP")
                // ),
                CustomButton(text: 'SignUp', onPressed: (){
                  widget.loginUser(
                    context,
                    widget.nameController.text,
                    widget.emailController.text,
                    widget.passwordController.text,
                  );
                })

              ],
            ),
          ),
        ),
      ),
    );
  }
}

