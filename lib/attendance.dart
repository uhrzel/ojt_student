// AttendanceScreen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ojt_student/dashboard.dart';
import 'package:ojt_student/main.dart';
import 'package:ojt_student/organization.dart';
import 'package:ojt_student/task.dart';
import 'package:ojt_student/attendance_scanner_morning.dart';
import 'package:ojt_student/attendance_scanner_afternoon.dart';
import 'package:http/http.dart' as http;

class AttendanceScreen extends StatelessWidget {
  late Future<Map<String, dynamic>> _futureData;
  final int userId; // Add userId parameter

  AttendanceScreen({required this.userId});
  // Constructor
  Future<Map<String, dynamic>> fetchData(int userId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.254.159/ojt_rms/student/index.php?user_id=$userId'));

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _futureData = fetchData(userId); // Initialize _futureData

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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                          'assets/images/student.png'), // Replace with actual user image
                    ),
                    SizedBox(height: 10),
                    FutureBuilder<Map<String, dynamic>>(
                      future: _futureData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error loading user data',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          );
                        } else {
                          final userEmail = snapshot.data?['email'];
                          final firstname = snapshot.data?['first_name'];
                          final lastname = snapshot.data?['last_name'];
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 3,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '$firstname $lastname',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 3,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '$userEmail',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
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
      body: Column(
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: _futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text(
                  'Error loading user data',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                );
              } else {
                // Extract attendance list from snapshot data
                final attendanceList = snapshot.data?['attendance'] ?? [];
                final firstname = snapshot.data?['first_name'];
                final lastname = snapshot.data?['last_name'];
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int index = 0;
                            index < attendanceList.length;
                            index++)
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent[100],
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
                                  '$firstname $lastname',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Time in: ${attendanceList[index]['attendance_time_in']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Time out: ${attendanceList[index]['attendance_time_out']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Date: ${attendanceList[index]['attendance_date']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                            height: 20), // Add additional spacing at the bottom
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeOption('AM', Colors.teal, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QRCodeScannerScreenMorning(userId: userId),
                      ),
                    );
                  }),
                  SizedBox(width: 20),
                  _buildTimeOption('PM', Colors.teal, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QRCodeScannerScreenAfternoon(userId: userId),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOption(
      String time, Color backgroundColor, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor, // Set the background color of the button
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Increased padding
        child: Text(
          time,
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold), // Larger text size
        ),
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
