import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set this property to false

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
          content: Text('successful registration'),
          duration: Duration(
              seconds:
                  2), // Duration for how long the SnackBar will be displayed
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
                hintText: 'Enter firstName',
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
                hintText: 'Enter your lastName',
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
                hintText: 'Enter your Contact number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _startDateController,
              decoration: InputDecoration(
                labelText: 'Start Date',
                hintText: 'Enter start Date',
                prefixIcon: Icon(Icons.calendar_month),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _courseController,
              decoration: InputDecoration(
                labelText: 'Course',
                hintText: 'Enter your Course',
                prefixIcon: Icon(Icons.list_alt),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _organizationController,
              decoration: InputDecoration(
                labelText: 'Organization',
                hintText: 'Enter your Organization',
                prefixIcon: Icon(Icons.list_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _schoolYearController,
              decoration: InputDecoration(
                labelText: 'School Year',
                hintText: 'Enter School Year',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _requiredHoursController,
              decoration: InputDecoration(
                labelText: 'Required Hours',
                hintText: 'Enter Required Training Hours',
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
                hintText: 'Enter your Address',
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
                hintText: 'Enter your Email',
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
                hintText: 'Enter your Password',
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
              width: 400, // Set the desired width
              child: ElevatedButton(
                onPressed: () {
                  _registerUser();
                },
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
