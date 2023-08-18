import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ojt_student/otp_verify.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  bool _isRegistering = false;

  Future<void> sendVerificationEmail(String email) async {
    setState(() {
      _isRegistering = true; // Set the flag to true before making the API call
    });
    final url =
        Uri.parse('http://192.168.254.159/ojt_rms/student/verify_email.php');
    final response = await http.post(url, body: {
      'email': email,
    });
    await Future.delayed(Duration(seconds: 2)); // Delay for 2 seconds
    setState(() {
      _isRegistering = false;
    });

    if (response.statusCode == 200) {
      String responsebody = response.body;
      String errorMessage = '';
      print(response.statusCode);
      print(response.body);

      if (responsebody.contains('Email not found')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email not found'),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (responsebody.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerifyScreen(email: email),
          ),
        );
      }
    } else {
      // Handle the error response, e.g., show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send verification email'),
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
            'Please wait.....',
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
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: _isRegistering
          ? _buildLinearProgressIndicator() // Call the function here
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String email = emailController.text;

                      _isRegistering ? null : sendVerificationEmail(email);
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ForgotPasswordScreen(),
  ));
}
