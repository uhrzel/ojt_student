import 'package:flutter/material.dart';
import 'package:ojt_student/main.dart';

class DashboardScreen extends StatelessWidget {
  final int userId;

  DashboardScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 76, 111, 200),
      appBar: AppBar(
        title: Text('Dashboard'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the Dashboard!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'User ID: $userId',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
