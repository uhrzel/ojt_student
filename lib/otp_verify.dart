import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OTPVerifyScreen extends StatefulWidget {
  final String email;

  OTPVerifyScreen({required this.email});

  @override
  _OTPVerifyScreenState createState() => _OTPVerifyScreenState();
}

class _OTPVerifyScreenState extends State<OTPVerifyScreen> {
  TextEditingController otpController = TextEditingController();
  bool _isVerifying = false;

  Future<void> verifyOTP(String otp, String email) async {
    setState(() {
      _isVerifying = true;
    });

    final url = Uri.parse('http://192.168.254.159/ojt_rms/student/otp.php');
    final response = await http.post(url, body: {
      'otp': otp,
      'email': email,
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isVerifying = false;
    });

    if (response.statusCode == 200) {
      String responsebody = response.body;
      String errorMessage = '';

      print(response.statusCode);
      print(response.body);

      if (responsebody.contains('Please fill in all fields')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all fields'),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (responsebody.contains('Incorrect OTP')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect OTP'),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (responsebody.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification Complete'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to verify OTP'),
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
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: _isVerifying
          ? _buildLinearProgressIndicator() // Call the function here
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Enter the OTP sent to ${widget.email}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: otpController,
                    decoration: InputDecoration(
                      labelText: 'OTP',
                      hintText: 'Enter the OTP',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String otp = otpController.text;
                      _isVerifying ? null : verifyOTP(otp, widget.email);
                    },
                    child: Text('Verify OTP'),
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
    home: OTPVerifyScreen(
        email: 'ortegacanillo76@gmail.com'), // Pass your email here
  ));
}
