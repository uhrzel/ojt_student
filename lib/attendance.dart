// AttendanceScreen.dart

import 'package:flutter/material.dart';
import 'package:ojt_student/dashboard.dart';
import 'package:ojt_student/main.dart';
import 'package:ojt_student/organization.dart';
import 'package:ojt_student/attendance.dart';
import 'package:ojt_student/task.dart';

class AttendanceScreen extends StatelessWidget {
  final int userId; // Add userId parameter

  AttendanceScreen({required this.userId}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 76, 111, 200),
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                        'assets/images/student.png'), // Replace with actual user image
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User ID: $userId',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            _buildListTile('Home', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DashboardScreen(
                          userId: userId,
                        )),
              );
              // Navigate to Home screen
            }),
            _buildListTile('Attendance', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AttendanceScreen(userId: userId)),
              );
              // Navigate to Attendance screen
            }),
            _buildListTile('Task', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskScreen(
                          userId: userId,
                        )),
              );
              // Navigate to Task screen
            }),
            _buildListTile('Organization', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrganizationScreen(
                          userId: userId,
                        )),
              );
              // Navigate to Organization screen
            }),
            _buildListTile('Logout', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }),
          ],
        ),
      ),
      body: Center(
        child: Text('Attendance Screen Content'),
      ),
    );
  }

  Widget _buildListTile(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Center(child: Text(title)),
          onTap: onTap,
        ),
      ),
    );
  }
}
