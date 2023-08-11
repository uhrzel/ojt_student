import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  void _registerUser() async {
    // Fetch data from the form controllers
    String studentIdNumber = _studentIdNumberController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String contactNumber = _contactNumberController.text;
    String startDate = _startDateController.text;
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
      Uri.parse(
          'http://192.168.254.159/ojt_rms/student/classes/Register.class.php'),
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

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('successful registration'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('failed registration !'),
          duration: Duration(
              seconds:
                  2), // Duration for how long the SnackBar will be displayed
        ),
      );
    }
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
              decoration: InputDecoration(labelText: 'Student ID Number'),
            ),
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: _contactNumberController,
              decoration: InputDecoration(labelText: 'Contact Number'),
            ),
            TextFormField(
              controller: _startDateController,
              decoration: InputDecoration(labelText: 'Start Date'),
            ),
            TextFormField(
              controller: _courseController,
              decoration: InputDecoration(labelText: 'Course'),
            ),
            TextFormField(
              controller: _organizationController,
              decoration: InputDecoration(labelText: 'Organization'),
            ),
            TextFormField(
              controller: _schoolYearController,
              decoration: InputDecoration(labelText: 'School Year'),
            ),
            TextFormField(
              controller: _requiredHoursController,
              decoration: InputDecoration(labelText: 'Required Hours'),
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _registerUser,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
