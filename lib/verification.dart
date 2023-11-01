import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ojt_student/main.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  bool _isSendingVerification = false;
  void _sendVerificationEmail() async {
    setState(() {
      _isSendingVerification = true;
    });

    String email = _emailController.text;
    String otp = _otpController.text;

    final response = await http.post(
      Uri.parse(
          'http://192.168.254.159:8080/ojt_rms/student/verify_account.php'),
      body: {'email': email, 'otp': otp},
    );

    setState(() {
      _isSendingVerification = false;
    });

    if (response.statusCode == 200) {
      String responseBody = response.body;
      print(responseBody);

      if (responseBody.contains('Please fill in all fields')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all fields'),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (responseBody.contains('Incorrect OTP')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect OTP'),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (responseBody.isNotEmpty) {
        // Display success modal using a Dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Account Verification Success'),
              content: Text('Your account has been successfully verified.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred, please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose(); // Dispose the OTP controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 76, 111, 200),
      appBar: AppBar(
        title: Text('Email Verification'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                child: Padding(
                  padding: EdgeInsets.only(left: 8), // Add left padding

                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        labelStyle: TextStyle(color: Colors.black)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                child: Padding(
                  padding: EdgeInsets.only(left: 8), // Add left padding

                  child: TextField(
                    controller: _otpController,
                    keyboardType: TextInputType
                        .number, // Specify the keyboard type for OTP
                    decoration: InputDecoration(
                        labelText: 'OTP',
                        hintText: 'Enter your OTP',
                        hintStyle:
                            TextStyle(color: Colors.grey), // Update the label
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        labelStyle: TextStyle(color: Colors.black)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed:
                    _isSendingVerification ? null : _sendVerificationEmail,
                child: Text('Verriy Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
