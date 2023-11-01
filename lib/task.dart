// AttendanceScreen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ojt_student/dashboard.dart';
import 'package:ojt_student/main.dart';
import 'package:ojt_student/organization.dart';
import 'package:ojt_student/attendance.dart';
import 'package:http/http.dart'
    as http; // Import the HTTP package for making API requests

class TaskScreen extends StatefulWidget {
  final int userId;

  TaskScreen({required this.userId});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class Task {
  final String taskId; // Add this property
  final String taskName;
  final String taskDescription;

  Task({
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
  });

  // Add a factory constructor to create a Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId:
          json['task_id'], // Make sure the JSON key matches the API response
      taskName: json['task_name'],
      taskDescription: json['task_description'],
    );
  }
}

class _TaskScreenState extends State<TaskScreen> {
  late Future<Map<String, dynamic>> _futureData;
  List<Task> tasks = []; // List to store tasks
  bool showTextFields = false; // Flag to control text field visibility
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();

  Future<Map<String, dynamic>> fetchData(int userId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.254.159:8080/ojt_rms/student/index.php?user_id=$userId'));

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> createTask() async {
    final apiUrl =
        "http://192.168.254.159:8080/ojt_rms/student/task_create.php"; // Replace with the actual API URL

    final response = await http.get(Uri.parse(
        "$apiUrl?student_id=${widget.userId}&task_name=${taskNameController.text}&task_description=${taskDescriptionController.text}"));

    if (response.statusCode == 200) {
      final result = response.body;
      if (result == "Cannot be empty") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Task Creation Error"),
              content: Text("Task name and description cannot be empty."),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Task Created"),
              content: Text("Task has been successfully created."),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // Handle API error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("API Error"),
            content: Text("An error occurred while creating the task."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> fetchTasks() async {
    final apiUrl =
        "http://192.168.254.159:8080/ojt_rms/student/tasks.php"; // Replace with the actual API URL

    final response = await http.get(Uri.parse(
        "$apiUrl?student_id=${widget.userId}&organization_id=some_organization_id"));

    if (response.statusCode == 200) {
      final List<dynamic> taskData = json.decode(response.body);

      tasks = taskData.map((taskJson) => Task.fromJson(taskJson)).toList();

      setState(() {});
    } else {
      // Handle API error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("API Error"),
            content: Text("An error occurred while fetching tasks."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _showCreateTaskModal() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Create Task"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: taskNameController,
                  decoration: InputDecoration(
                    labelText: "Task Name",
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: taskDescriptionController,
                  decoration: InputDecoration(
                    labelText: "Task Description",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                createTask();
                _refreshIndicatorKey.currentState
                    ?.show(); // Close the dialog after task creation
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: Text("Create Task"),
            ),
            ElevatedButton(
              onPressed: () {
                _refreshIndicatorKey.currentState?.show();
                Navigator.pop(context);
                // Close the dialog without creating a task
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String taskId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                _refreshIndicatorKey.currentState?.show();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                deleteTask(taskId);
                _refreshIndicatorKey.currentState?.show();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleted Data'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void deleteTask(String taskId) async {
    final apiUrl =
        "http://192.168.254.159:8080/ojt_rms/student/task_delete.php"; // Replace with the actual API URL

    final response = await http.get(Uri.parse("$apiUrl?task_id=$taskId"));

    if (response.statusCode == 200) {
      final result = response.body;
      // Handle the result (success or error) as needed
    } else {
      // Handle API error
    }
  }

  @override
  void initState() {
    super.initState();
    _futureData = fetchData(widget.userId);
    fetchTasks(); // Fetch tasks when the screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 76, 111, 200),
      appBar: AppBar(
        title: Text('My Task'),
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
                    builder: (context) =>
                        DashboardScreen(userId: widget.userId)),
              );
              // Navigate to Home screen
            }),
            _buildListTile('Attendance', Icons.calendar_today, 16, () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AttendanceScreen(userId: widget.userId)),
              );
              // Navigate to Attendance screen
            }),
            _buildListTile('Task', Icons.assignment, 16, () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskScreen(
                          userId: widget.userId,
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
                          userId: widget.userId,
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
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: fetchTasks, // Call fetchTasks when refreshing
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent[100],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Card(
                        color: Colors
                            .transparent, // Set the background color to transparent

                        elevation:
                            0, // No elevation for the card since shadow is provided by the container
                        child: ListTile(
                          title: Text(
                            tasks[index].taskName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text(tasks[index].taskDescription,
                              style: TextStyle(color: Colors.white)),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteConfirmationDialog(
                                  tasks[index].taskId);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 100.0), // Adjust horizontal padding
                child: ElevatedButton(
                  onPressed: () {
                    _showCreateTaskModal();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Create Task",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
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
