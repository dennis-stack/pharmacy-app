import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacyApp/common_widgets/app_button.dart';
import 'package:pharmacyApp/connection/connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsPage extends StatefulWidget {
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _firstNameController.text = preferences.getString('firstName') ?? '';
      _lastNameController.text = preferences.getString('lastName') ?? '';
      _phoneNoController.text = preferences.getString('phoneNo') ?? '';
      _emailController.text = preferences.getString('email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Details"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Personal Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: "First Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _phoneNoController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  enabled: false,
                ),
                SizedBox(height: 20),
                Text(
                  "Change Password",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: "Confirm New Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                AppButton(
                  label: 'Save Changes',
                  onPressed: () async {
                    final firstName = _firstNameController.text;
                    final lastName = _lastNameController.text;
                    final phoneNumber = _phoneNoController.text;
                    final password = _passwordController.text;
                    final confirmPassword = _confirmPasswordController.text;

                    if (_firstNameController.text.isEmpty ||
                        _lastNameController.text.isEmpty ||
                        _phoneNoController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'Please fill all fields',
                        gravity: ToastGravity.BOTTOM,
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.red,
                      );
                      return;
                    }

                    if (password != confirmPassword) {
                      // Show error message if passwords don't match
                      Fluttertoast.showToast(
                        msg: 'Passwords do not match',
                        gravity: ToastGravity.BOTTOM,
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.red,
                      );
                      return;
                    }

                    final phoneRegex = RegExp(r'^07[0-9]{8}$');
                    if (!phoneRegex.hasMatch(_phoneNoController.text)) {
                      Fluttertoast.showToast(
                        msg:
                            'Please enter a valid phone number starting with 07 and having 10 digits only',
                        gravity: ToastGravity.BOTTOM,
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: Colors.red,
                      );
                      return;
                    }

                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    final savedFirstName = preferences.getString('firstName');
                    final savedLastName = preferences.getString('lastName');
                    final savedPhoneNumber = preferences.getString('phoneNo');
                    final currentPassword = preferences.getString('password');

                    bool shouldUpdate =
                        false; // Flag to track if an update is required

                    if (firstName != savedFirstName ||
                        lastName != savedLastName ||
                        phoneNumber != savedPhoneNumber) {
                      // At least one of the details has changed
                      shouldUpdate = true;
                    }

                    if (password.isNotEmpty && password != currentPassword) {
                      // Password has changed
                      shouldUpdate = true;
                    }

                    if (!shouldUpdate) {
                      Fluttertoast.showToast(
                        msg: 'User details are still the same',
                        gravity: ToastGravity.BOTTOM,
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: Colors.blue,
                      );
                      return;
                    }

                    final url = API.update;
                    final response = await http.post(
                      Uri.parse(url),
                      headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                      },
                      body: {
                        'firstName': firstName,
                        'lastName': lastName,
                        'phoneNo': phoneNumber,
                        'email': _emailController.text,
                        'password': password,
                      },
                    );

                    if (response.statusCode == 200) {
                      final data = json.decode(response.body);
                      final success = data['success'];

                      if (success) {
                        preferences.setString('firstName', firstName);
                        preferences.setString('lastName', lastName);
                        preferences.setString('phoneNo', phoneNumber);

                        // Only update the password if it is not empty
                        if (password.isNotEmpty) {
                          if (password.length < 8) {
                            Fluttertoast.showToast(
                              msg: 'Password must have at least 8 characters',
                              gravity: ToastGravity.BOTTOM,
                              toastLength: Toast.LENGTH_SHORT,
                              backgroundColor: Colors.red,
                            );
                            return;
                          } else {
                            preferences.setString('password', password);
                          }
                        }

                        // Show success message
                        Fluttertoast.showToast(
                          msg: 'User details updated successfully',
                          gravity: ToastGravity.BOTTOM,
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.green,
                        );
                      } else {
                        // Show error message from the backend
                        final message = data['message'];
                        Fluttertoast.showToast(
                          msg: 'Failed to update user details: $message',
                          gravity: ToastGravity.BOTTOM,
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.red,
                        );
                      }
                    } else {
                      // Show error message
                      Fluttertoast.showToast(
                        msg: 'Failed to update user details. Please try again.',
                        gravity: ToastGravity.BOTTOM,
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
