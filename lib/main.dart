import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ojt_student/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set this property to false
      title: 'Login Page',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _login() async {
    final url = Uri.parse('http://192.168.254.159/ojt_rms/student/signin.php');
    final response = await http.post(url, body: {
      'email': emailController.text,
      'password': passwordController.text,
    });

    if (response.statusCode == 200) {
      // Successful login, handle the response here
      final responseData = json.decode(response.body);

      // Check if the email exists in the API response
      if (responseData['emailExists'] == true) {
        // Email is valid, you can proceed with further logic
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Successful'),
            duration: Duration(
                seconds:
                    2), // Duration for how long the SnackBar will be displayed
          ),
        );
      } else {
        // Email is not valid or not found in the database
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid email or password'),
            duration: Duration(
                seconds:
                    2), // Duration for how long the SnackBar will be displayed
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${response.statusCode}'),
          duration: Duration(
              seconds:
                  2), // Duration for how long the SnackBar will be displayed
        ),
      );
      // Error occurred, handle the error here

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo and Text
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png', // Replace with your logo image path
                          height: 200,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            'OJT RMS',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.amberAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Align(
                    // Use the Align widget to align the text to the left
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        // Implement forgot password logic
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: _login, //for login
                    style: ElevatedButton.styleFrom(
                      // Apply the same style as the "Login" button
                      primary: Colors.blueGrey,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationForm()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      // Apply the same style as the "Login" button
                      primary: Color.fromARGB(255, 104, 118, 110),
                      padding: EdgeInsets.symmetric(vertical: 30),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
