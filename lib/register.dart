import 'dart:convert';
import 'package:flutter/cupertino.dart'; // YearPicker is available in the Cupertino library
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registration App',
      home: RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  TextEditingController _studentIdNumberController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _courseController = TextEditingController();
  TextEditingController _organizationController = TextEditingController();
  TextEditingController _schoolYearController = TextEditingController();
  TextEditingController _requiredHoursController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String? selectedCourse;
  String? selectedOrganization;

  late DateTime _selectedDate = DateTime.now();

  void _registerUser() async {
    // Fetch data from the form controllers
    String studentIdNumber = _studentIdNumberController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String contactNumber = _contactNumberController.text;
    String startDate = _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate)
        : '';
    String course = _courseController.text;
    String organization = _organizationController.text;
    String schoolYear = _schoolYearController.text;
    String requiredHours = _requiredHoursController.text;
    String address = _addressController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Check if passwords match
    if (password != confirmPassword) {
      // Show an error message that passwords do not match
      return;
    }

    // Call the API to register the user
    final response = await http.post(
      Uri.parse('http://192.168.254.159/ojt_rms/student/signup.php'),
      body: {
        'student_id_number': studentIdNumber,
        'first_name': firstName,
        'last_name': lastName,
        'contact_number': contactNumber,
        'start_date': startDate,
        'course_id': course,
        'organization_id': organization,
        'school_year': schoolYear,
        'required_hours': requiredHours,
        'address': address,
        'user_email': email,
        'user_password': password,
      },
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    // Handle the API response here
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successful registration'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed registration!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

// Add this function to your _RegistrationFormState class
  List<String> courseCodes = []; // List to store fetched course codes
  Future<void> fetchCourseCodes() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.254.159/ojt_rms/student/fetch_courseCode.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          courseCodes = List<String>.from(data);
        });
      } else {
        print('Failed to fetch course codes');
      }
    } catch (e) {
      print('Error fetching course codes: $e');
    }
  }

  // Add this function to your _RegistrationFormState class
  List<String> organizationName = []; // List to store fetched course codes
  Future<void> fetchOrganizationName() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.254.159/ojt_rms/student/fetch_organizationName.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          organizationName = List<String>.from(data);
        });
      } else {
        print('Failed to fetch course codes');
      }
    } catch (e) {
      print('Error fetching course codes: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCourseCodes();
    fetchOrganizationName(); // Fetch course codes when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Form'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _studentIdNumberController,
              decoration: InputDecoration(
                labelText: 'Student ID Number',
                hintText: 'Enter your ID Number',
                prefixIcon: Icon(Icons.numbers),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                hintText: 'Enter first name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                hintText: 'Enter your last name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _contactNumberController,
              decoration: InputDecoration(
                labelText: 'Contact Number',
                hintText: 'Enter your contact number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null && pickedDate != _selectedDate) {
                  setState(() {
                    _selectedDate = pickedDate;
                    _startDateController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    hintText: 'Select start date',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<String>(
              value: selectedCourse,
              onChanged: (value) {
                setState(() {
                  selectedCourse = value;
                  _courseController.text = value!;
                });
              },
              items: courseCodes.map((courseCode) {
                return DropdownMenuItem<String>(
                  value: courseCode,
                  child: Text(courseCode),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Course',
                hintText: 'Select your course',
                prefixIcon: Icon(Icons.list_alt),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<String>(
              value: selectedOrganization,
              onChanged: (value) {
                setState(() {
                  selectedOrganization = value;
                  _organizationController.text = value!;
                });
              },
              items: organizationName.map((organizationame) {
                return DropdownMenuItem<String>(
                  value: organizationame,
                  child: Text(organizationame),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Organization',
                hintText: 'Select your Organization',
                prefixIcon: Icon(Icons.list_alt),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                DateTime? pickedYear = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 10),
                  lastDate: DateTime(DateTime.now().year + 10),
                  initialDatePickerMode: DatePickerMode.year,
                );

                if (pickedYear != null) {
                  setState(() {
                    _selectedDate = pickedYear;
                    _schoolYearController.text = pickedYear.year.toString();
                  });
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _schoolYearController,
                  decoration: InputDecoration(
                    labelText: 'School Year',
                    hintText: 'Select school year',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _requiredHoursController,
              decoration: InputDecoration(
                labelText: 'Required Hours',
                hintText: 'Enter required training hours',
                prefixIcon: Icon(Icons.lock_clock),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                hintText: 'Enter your address',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Confirm your password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 50,
              width: 400,
              child: ElevatedButton(
                onPressed: _registerUser,
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
