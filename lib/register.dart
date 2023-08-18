import 'dart:convert';
// YearPicker is available in the Cupertino library
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ojt_student/verification.dart';

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
  bool _isRegistering = false; // Track registration state

  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Account Created'),
          content: Text(
            'Account created successfully. Please check your email for verification.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerificationPage()),
                );
                // Navigate to the verification page here
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => VerificationPage()));
              },
              child: Text('Proceed to Verification'),
            ),
          ],
        );
      },
    );
  }

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
    setState(() {
      _isRegistering = true; // Set registration state to true
    });

    bool _hasEmptyFields() {
      return _studentIdNumberController.text.isEmpty ||
          _firstNameController.text.isEmpty ||
          _lastNameController.text.isEmpty ||
          _contactNumberController.text.isEmpty ||
          _startDateController.text.isEmpty ||
          _courseController.text.isEmpty ||
          _organizationController.text.isEmpty ||
          _schoolYearController.text.isEmpty ||
          _requiredHoursController.text.isEmpty ||
          _addressController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty;
    }

    // Check for empty fields
    if (_hasEmptyFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all the required fields'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        _isRegistering = false; // Set registration state to false
      });
      return;
    }

    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please match your password'),
          duration: Duration(seconds: 2),
        ),
      );
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
    await Future.delayed(Duration(seconds: 2)); // Delay for 2 seconds
    setState(() {
      _isRegistering = false;
    });

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    // Handle the API response here
    if (response.statusCode == 200) {
      String responseBody = response.body; // Extract the response body
      String errorMessage = ''; // Initialize the error message variable

      if (responseBody.contains('Email or Student ID Number already exists')) {
        errorMessage = 'Email or Student ID Number already exists';
      } else if (responseBody.contains('All fields are required')) {
        errorMessage = 'All fields are required';
      } else if (responseBody.contains(
          'Account created successfully. Please check your email for verification.')) {
        // Display the error message in the SnackBar
        _showVerificationDialog();

        return; // Exit the function since registration was successful
      } else {
        errorMessage = 'Something went wrong';
      }

      // Display the error message in the SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed registration! $errorMessage'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Handle other error cases based on the status code
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Failed registration! Error code: ${response.statusCode}'),
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
  void dispose() {
    _studentIdNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _contactNumberController.dispose();
    _startDateController.dispose();
    _courseController.dispose();
    _organizationController.dispose();
    _schoolYearController.dispose();
    _requiredHoursController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
            'Registering...',
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
        title: Text('Registration Form'),
      ),
      body: _isRegistering
          ? _buildLinearProgressIndicator() // Call the function here
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: _studentIdNumberController,
                      decoration: InputDecoration(
                        labelText: 'Student ID Number',
                        hintText: 'Enter your ID Number',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        hintText: 'Enter first name',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        hintText: 'Enter your last name',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: _contactNumberController,
                      decoration: InputDecoration(
                        labelText: 'Contact Number',
                        hintText: 'Enter your contact number',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: GestureDetector(
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
                            labelStyle: TextStyle(color: Colors.grey),
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: DropdownButtonFormField<String>(
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
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.list_alt),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: DropdownButtonFormField<String>(
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
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.list_alt),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: GestureDetector(
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
                            _schoolYearController.text =
                                pickedYear.year.toString();
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _schoolYearController,
                          decoration: InputDecoration(
                            labelText: 'School Year',
                            hintText: 'Select school year',
                            labelStyle: TextStyle(color: Colors.grey),
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: _requiredHoursController,
                      decoration: InputDecoration(
                        labelText: 'Required Hours',
                        hintText: 'Enter required training hours',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.lock_clock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        hintText: 'Enter your address',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.home),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Confirm your password',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: 500,
                    height: 60, // Set the desired width
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Padding background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextButton(
                      onPressed: _isRegistering ? null : _registerUser,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets
                            .zero, // Remove default TextButton padding
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
