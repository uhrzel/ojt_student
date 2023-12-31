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
import 'package:intl/intl.dart'; // Import the intl package

class AttendanceScreen extends StatefulWidget {
  final int userId; // Add userId parameter
  AttendanceScreen({required this.userId});

  @override
  _AttendanceScreenState createState() =>
      _AttendanceScreenState(userId: userId);
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isSearching = false; // To track whether the search field is active
  final int userId; // Add userId parameter
  late Future<Map<String, dynamic>> _futureData;
  Stream<DateTime> TimeStream =
      Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
  TextEditingController searchController = TextEditingController();
  String _searchText = ''; // Add this at the beginning of your class
// Define this at the beginning of your class

  _AttendanceScreenState({required this.userId});
  // Constructor
  Future<Map<String, dynamic>> fetchData(int userId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.254.159:8080/ojt_rms/student/index.php?user_id=$userId'));

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _futureData = fetchData(userId); // Initialize _futureData
    Stream<DateTime> timeStream =
        Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 76, 111, 200),
      appBar: AppBar(
        title: Text('Attendance'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 16.0), // Adjust the padding as needed
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching; // Toggle search field state
                  print("_isSearching: $_isSearching"); // Add this line
                });
              },
            ),
          ),
          if (_isSearching)
            Container(
              alignment:
                  Alignment.centerRight, // Align the TextField to the right
              child: SizedBox(
                width: 150, // Set the desired width for the TextField
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by Date',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                          searchController.clear();
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                ),
              ),
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                                width: double
                                    .infinity, // Set the width to the maximum available width

                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 3,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),

                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blueAccent[100],
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          'assets/images/student.png'), // Replace with actual user image
                                    ),
                                    Text(
                                      '$firstname $lastname',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '$userEmail',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
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
            _buildListTile('Home', Icons.home, 16, () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DashboardScreen(userId: userId)),
              );
            }),
            _buildListTile('Attendance', Icons.calendar_today, 16, () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AttendanceScreen(userId: userId)),
              );
              // Navigate to Attendance screen
            }),
            _buildListTile('Task', Icons.assignment, 16, () {
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
            _buildListTile('Organization', Icons.school_outlined, 16, () {
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
            _buildListTile('Logout', Icons.login_outlined, 16, () {
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
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.teal, // Background color
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.access_time,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                StreamBuilder<DateTime>(
                  stream: TimeStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error loading date and time',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      );
                    } else {
                      return Column(
                        children: [
                          Text(
                            'Time: ${DateFormat('hh:mm:ss a').format(snapshot.data!)}', // Format includes time with seconds
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                final attendanceList = snapshot.data?['attendance'] ?? [];
                final firstname = snapshot.data?['first_name'];
                final lastname = snapshot.data?['last_name'];

                final filteredAttendanceList =
                    attendanceList.where((attendance) {
                  final date = attendance['attendance_date']
                      .toString()
                      .toLowerCase(); // Convert to lowercase
                  final searchText = _searchText
                      .toLowerCase(); // Convert search text to lowercase

                  print('Date from list: $date');
                  print('Search text: $_searchText');

                  return date.contains(searchText);
                }).toList();

                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int index = 0;
                            index < filteredAttendanceList.length;
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
                                  '${attendanceList[index]['attendance_log']} Attendance',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
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

  Widget _buildListTile(
      String title, IconData iconData, double fontSize, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(
            iconData,
            color: Colors.black,
          ), // Add the icon as the leading widget
          title: Text(
            title,
            style: TextStyle(fontSize: fontSize), // Set the font size
          ), // Display the title without Center widget
          onTap: onTap,
        ),
      ),
    );
  }
}
