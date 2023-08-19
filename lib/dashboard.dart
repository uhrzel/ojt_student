import 'package:flutter/material.dart';
import 'package:ojt_student/main.dart';
import 'package:ojt_student/organization.dart';
import 'package:ojt_student/attendance.dart';
import 'package:ojt_student/task.dart';

class DashboardScreen extends StatelessWidget {
  final int userId;

  DashboardScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 76, 111, 200),
      appBar: AppBar(
        title: Text('Dashboard'),
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
      body: Column(
        children: [
          SizedBox(height: 20), // Add space between app bar and boxes
          Row(
            children: [
              SizedBox(width: 20), // Add left margin
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 10), // Add right margin
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Remaining Hours',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '8 hours', // Replace with actual remaining hours
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10), // Add left margin
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tasks Created',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '5 tasks', // Replace with actual tasks count
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20), // Add right margin
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: 400,
            margin: EdgeInsets.symmetric(
                horizontal: 20), // Add left and right margin
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Task Assigned',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '3 tasks assigned', // Replace with actual assigned tasks count
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
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
