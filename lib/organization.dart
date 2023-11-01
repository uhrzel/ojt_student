// AttendanceScreen.dart

import 'package:flutter/material.dart';
import 'package:ojt_student/main.dart';
import 'package:ojt_student/attendance.dart';
import 'package:ojt_student/task.dart';
import 'package:ojt_student/dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrganizationScreen extends StatelessWidget {
  final int userId;
  late Future<Map<String, dynamic>> _futureData;

  OrganizationScreen({required this.userId});

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

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 76, 111, 200),
      appBar: AppBar(
        title: Text('organization'),
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
            _buildListTile('Logout', Icons.logout_outlined, 16, () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading organization data',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          } else {
            final organization = snapshot.data?['organization'];
            final organizationName = organization['organization_name'];
            final organizationDescription =
                organization['organization_description'];
            final ornazationContactNumber =
                organization['organization_contact_number'];
            final organizationAddress = organization['organization_address'];
            final organizationEmail = organization['organization_email'];
            final coordinators = snapshot.data?['coordinator'];
            final coordinatorFirstName =
                coordinators.isNotEmpty ? coordinators[0]['first_name'] : 'N/A';
            final coordinatorLastName =
                coordinators.isNotEmpty ? coordinators[0]['last_name'] : 'N/A';
            final student = snapshot.data?['user'];
            final studentFirstName = student['first_name'];
            final studentLastName = student['last_name'];
            final studentSY = student['school_year'];
            final studentContactNumber = student['contact_number'];
            final studentAddress = student['address'];
            final course = snapshot.data?['course'];
            final courseCode = course['course_code'];

            return SingleChildScrollView(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(
                      10), // Add some margin around the container
                  decoration: BoxDecoration(
                    /* color: Color.fromARGB(255, 76, 111, 200), */
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      buildCardListTile(
                        icon: Icons.school,
                        title: 'Student name:',
                        subtitle: '$studentFirstName $studentLastName',
                      ),
                      buildCardListTile(
                        icon: Icons.list_alt_rounded,
                        title: 'Course:',
                        subtitle: courseCode,
                      ),
                      buildCardListTile(
                        icon: Icons.calendar_today,
                        title: 'Schol year:',
                        subtitle: studentSY,
                      ),
                      buildCardListTile(
                        icon: Icons.home_filled,
                        title: 'Address:',
                        subtitle: studentAddress,
                      ),
                      buildCardListTile(
                        icon: Icons.contact_phone,
                        title: 'Contact Nmber:',
                        subtitle: studentContactNumber,
                      ),
                      buildCardListTile(
                        icon: Icons.man,
                        title: 'Coordinator Name:',
                        subtitle: coordinators.isNotEmpty
                            ? '${coordinatorFirstName} ${coordinatorLastName}'
                            : 'No Coordinator Assigned',
                      ),
                      buildCardListTile(
                        icon: Icons.corporate_fare_outlined,
                        title: 'Organization:',
                        subtitle: organizationName,
                      ),
                      buildCardListTile(
                        icon: Icons.email_outlined,
                        title: 'email:',
                        subtitle: organizationEmail,
                      ),
                      buildCardListTile(
                        icon: Icons.description_rounded,
                        title: 'Description:',
                        subtitle: organizationDescription,
                      ),
                      buildCardListTile(
                        icon: Icons.maps_home_work_sharp,
                        title: 'Address:',
                        subtitle: organizationAddress,
                      ),
                      buildCardListTile(
                        icon: Icons.phone_callback_rounded,
                        title: 'Contact Number:',
                        subtitle: ornazationContactNumber,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
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

  Widget buildCardListTile(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Card(
        color: Colors.blueAccent[100],
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.white,
          ), // Icon as the leading widget
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ), // Font size and bold title
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ), // Font size for subtitle
          ),
        ),
      ),
    );
  }
}
