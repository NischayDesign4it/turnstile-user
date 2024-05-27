import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:turnstile_user/presentation/signupScreen.dart';

import '../customWidget/customButton.dart';
import 'dashboardScreen.dart';
import 'package:turnstile_user/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    final String apiUrl = 'http://54.163.33.217:8000/loginapi/';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Login response: $responseData');

        // Check if the response indicates successful login
        if (responseData['message'] == 'Login successful') {
          globals.loggedInUserEmail = email;
          globals.loggedInUserName = responseData['name'];
          print(globals.loggedInUserEmail);
          print(globals.loggedInUserName);

          // Navigate to the home screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        } else {
          // Handle login failure
          print('Login failed. Message: ${responseData['message']}');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Incorrect email or password. Please try again.'),
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
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
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(title: '', backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Image.asset('assets/images/icon-light.png'),
                ),
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
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                // ElevatedButton(
                //
                //   onPressed: () {
                //     widget.loginUser(
                //       context,
                //       widget.emailController.text,
                //       widget.passwordController.text,
                //     );
                //   }, child: Text("LOGIN"),
                // ),
                CustomButton(
                    text: 'Login',
                    onPressed: () {
                      widget.loginUser(
                        context,
                        widget.emailController.text,
                        widget.passwordController.text,
                      );
                    }),

                SizedBox(height: 20),
                new GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: Text("Don't have an account? SignUp",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
