import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ojt_student/forgot_pass.dart';
import 'package:ojt_student/register.dart';
import 'package:ojt_student/dashboard.dart';

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
  bool _isRegistering = false;

  void _login() async {
    setState(() {
      _isRegistering = true; // Set the flag to true before making the API call
    });
    final url = Uri.parse('http://192.168.254.159/ojt_rms/student/signin.php');
    final response = await http.post(url, body: {
      'email': emailController.text,
      'password': passwordController.text,
    });
    await Future.delayed(Duration(seconds: 2)); // Delay for 2 seconds
    setState(() {
      _isRegistering = false;
    });
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      String responseBody = response.body; // Extract the response body
      String errorMessage = ''; // Initialize the error message variable
      if (responseBody.contains('Email not found')) {
        /*  errorMessage = 'Email not found'; */
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email Not Found'),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (responseBody.contains('Incorrect password')) {
        /*  errorMessage = 'Incorrect password'; */
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect password'),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (responseBody.contains('Please fill in all fields')) {
        /*      errorMessage = 'Please fill in all fields'; */
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all fields'),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (responseBody.contains('Account not verified')) {
        /*     errorMessage = 'Account not verified'; */
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account not verified'),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (responseBody.isNotEmpty) {
        int? userId = int.tryParse(responseBody);

        if (userId != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(userId: userId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: Invalid response data'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${response.statusCode}'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildLinearProgressIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            color: Colors.grey.withOpacity(0.5),
            child: LinearProgressIndicator(),
          ),
          SizedBox(height: 50), // Add some spacing
          Text(
            'Login...',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 76, 111, 200),
      body: _isRegistering
          ? _buildLinearProgressIndicator() // Call the function here
          : Container(
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
                                  color: Colors.blueAccent[100],
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
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(
                                255, 58, 88, 165), // A slightly darker shade
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter email',
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(
                                255, 58, 88, 165), // A slightly darker shade
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter password',
                              labelText: 'Password',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Align(
                          // Use the Align widget to align the text to the left
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen()),
                              );
                              // Implement forgot password logic
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextButton(
                          onPressed: _isRegistering ? null : _login, //for login
                          style: ElevatedButton.styleFrom(
                            // Apply the same style as the "Login" button
                            primary: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),

                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 76, 111, 200),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        CupertinoButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => RegistrationForm(),
                              ),
                            );
                          },
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
