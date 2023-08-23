import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ojt_student/main.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String responseBody;

  ChangePasswordScreen({required this.responseBody});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _isChangingPassword = false;

  String userId = ''; // Initialize userId

  @override
  void initState() {
    super.initState();
    userId = widget.responseBody; // Set userId from the responseBody
  }

  Future<void> changePassword(String userId, String password) async {
    setState(() {
      _isChangingPassword = true;
    });

    final url =
        Uri.parse('http://192.168.254.159/ojt_rms/student/change_password.php');
    final response = await http.post(url, body: {
      'user_id': widget.responseBody,
      'password': password,
    });

    if (response.statusCode == 200) {
      String responsebody = response.body;

      print(response.statusCode);
      print(response.body);

      if (responsebody.contains('Please fill in all fields')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please fill in all fields"),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (responsebody.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Password has been changed!'),
              content: Text('Please proceed to login'),
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
          content: Text('Failed to change password'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      _isChangingPassword = false;
    });
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
        title: Text('Change Password'),
      ),
      body: _isChangingPassword
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
                      color: Colors.teal, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        hintText: 'Enter your new password',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Confirm your new password',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isChangingPassword
                        ? null
                        : () {
                            String newPassword = passwordController.text;
                            String confirmPassword =
                                confirmPasswordController.text;

                            if (newPassword == confirmPassword) {
                              changePassword(widget.responseBody, newPassword);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Passwords do not match'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                    child: Text('Change Password'),
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
    home: ChangePasswordScreen(
      responseBody: '123', // Pass the responseBody here
    ),
  ));
}
