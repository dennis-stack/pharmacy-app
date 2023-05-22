import 'package:flutter/material.dart';
import 'package:pharmacyApp/common_widgets/app_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

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

    // Initialize form fields with current user data
    final user = FirebaseAuth.instance.currentUser;
    _firstNameController.text = user?.displayName?.split(' ')[0] ?? '';
    _lastNameController.text = user?.displayName?.split(' ')[1] ?? '';
    _phoneNoController.text = user?.phoneNumber ?? '';
    _emailController.text = user?.email ?? '';
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
                    )),
                SizedBox(height: 20),
                AppButton(
                  label: 'Save Changes',
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    final firstName = _firstNameController.text;
                    final lastName = _lastNameController.text;
                    final phoneNumber = _phoneNoController.text;
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    final confirmPassword = _confirmPasswordController.text;

                    if (firstName.isEmpty ||
                        lastName.isEmpty ||
                        phoneNumber.isEmpty ||
                        password.isEmpty ||
                        confirmPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    if (password != confirmPassword) {
                      // Show error message if passwords don't match
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Passwords do not match')));
                      return;
                    }

                    if (_passwordController.text.length < 8) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Password must have at least 8 characters'),
                      ));
                      return;
                    }

                    final phoneRegex = RegExp(r'^07[0-9]{8}$');
                    if (!phoneRegex.hasMatch(_phoneNoController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Please enter a valid phone number starting with 07 and having 10 digits only'),
                      ));
                      return;
                    }

                    try {
                      await user?.updateDisplayName('$firstName $lastName');
                      if (password.isNotEmpty) {
                        await user?.updatePassword(password);
                      }
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user?.uid)
                          .update({
                        'firstName': firstName,
                        'lastName': lastName,
                        'phoneNo': phoneNumber,
                        'email': email,
                      });
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('User details updated successfully')));
                    } catch (error) {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
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
