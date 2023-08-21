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
  List<Task> tasks = []; // List to store tasks
  bool showTextFields = false; // Flag to control text field visibility
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();

  Future<void> createTask() async {
    final apiUrl =
        "http://192.168.254.159/ojt_rms/student/task_create.php"; // Replace with the actual API URL

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
        "http://192.168.254.159/ojt_rms/student/tasks.php"; // Replace with the actual API URL

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
              child: Text("Create Task"),
            ),
            ElevatedButton(
              onPressed: () {
                _refreshIndicatorKey.currentState?.show();
                Navigator.pop(context);
                // Close the dialog without creating a task
              },
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
        "http://192.168.254.159/ojt_rms/student/task_delete.php"; // Replace with the actual API URL

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
    fetchTasks(); // Fetch tasks when the screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 76, 111, 200),
      appBar: AppBar(
        title: Text('TaskScreen'),
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
                    'User ID: ${widget.userId}',
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
                          userId: widget.userId,
                        )),
              );
              // Navigate to Home screen
            }),
            _buildListTile('Attendance', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AttendanceScreen(userId: widget.userId)),
              );
              // Navigate to Attendance screen
            }),
            _buildListTile('Task', () {
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
            _buildListTile('Organization', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OrganizationScreen(userId: widget.userId)),
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
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        tasks[index].taskName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(tasks[index].taskDescription),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(tasks[index].taskId);
                        },
                      ),
                    ),
                  );
                },
              )),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 100.0), // Adjust horizontal padding
                child: ElevatedButton(
                  onPressed: () {
                    _showCreateTaskModal();
                  },
                  style: ElevatedButton.styleFrom(
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
