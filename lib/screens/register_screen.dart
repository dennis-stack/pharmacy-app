import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pharmacyApp/common_widgets/app_button.dart';
import 'package:pharmacyApp/common_widgets/toast_message.dart';
import 'package:pharmacyApp/connection/connection.dart';
import 'package:pharmacyApp/models/customer.dart';
import 'package:pharmacyApp/screens/login_screen.dart';
import 'package:pharmacyApp/common_widgets/login_link.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneNoController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  bool _showError = false;
  bool _showPasswordMatchError = false;
  bool _showWeakPasswordError = false;
  bool _showEmailExistsError = false;
  bool _showEmailFormatError = false;
  bool _showPhoneNumberFormatError = false;
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _phoneNumberRegex = RegExp(r"^07\d{8}$");
  bool _isObscure = true;
  bool _isConfirmObscure = true;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneNoController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 250,
                        ),
                        textField(),
                        SizedBox(height: 20),
                        AppButton(
                            label: 'Register',
                            onPressed: () {
                              if (firstNameController.text.isEmpty ||
                                  lastNameController.text.isEmpty ||
                                  phoneNoController.text.isEmpty ||
                                  emailController.text.isEmpty ||
                                  passwordController.text.isEmpty ||
                                  confirmPasswordController.text.isEmpty) {
                                setState(() {
                                  _showError = true;
                                  _showPasswordMatchError = false;
                                  _showWeakPasswordError = false;
                                  _showEmailExistsError = false;
                                  _showEmailFormatError = false;
                                  _showPhoneNumberFormatError = false;
                                });
                              } else if (passwordController.text !=
                                  confirmPasswordController.text) {
                                setState(() {
                                  _showError = false;
                                  _showPasswordMatchError = true;
                                  _showWeakPasswordError = false;
                                  _showEmailExistsError = false;
                                  _showEmailFormatError = false;
                                  _showPhoneNumberFormatError = false;
                                });
                              } else if (passwordController.text.length < 8) {
                                setState(() {
                                  _showError = false;
                                  _showPasswordMatchError = false;
                                  _showWeakPasswordError = true;
                                  _showEmailExistsError = false;
                                  _showEmailFormatError = false;
                                  _showPhoneNumberFormatError = false;
                                });
                              } else if (!_emailRegex
                                  .hasMatch(emailController.text)) {
                                setState(() {
                                  _showError = false;
                                  _showPasswordMatchError = false;
                                  _showWeakPasswordError = false;
                                  _showEmailExistsError = false;
                                  _showPhoneNumberFormatError = false;
                                  _showEmailFormatError = true;
                                });
                              } else if (!_phoneNumberRegex
                                  .hasMatch(phoneNoController.text)) {
                                setState(() {
                                  _showError = false;
                                  _showPasswordMatchError = false;
                                  _showWeakPasswordError = false;
                                  _showEmailExistsError = false;
                                  _showEmailFormatError = false;
                                  _showPhoneNumberFormatError = true;
                                });
                              } else if (formKey.currentState!.validate()) {
                                setState(() {
                                  _showError = false;
                                  _showPasswordMatchError = false;
                                  _showWeakPasswordError = false;
                                  _showEmailExistsError = false;
                                  _showEmailFormatError = false;
                                  _showPhoneNumberFormatError = false;
                                });
                                registerUser();
                              }
                            }),
                        SizedBox(height: 10),
                        LoginLink(
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textField() {
    return Column(
      children: [
        TextFormField(
          controller: firstNameController,
          decoration: const InputDecoration(
            hintText: 'Enter your first name',
            icon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: 7.0),
        TextFormField(
          controller: lastNameController,
          decoration: const InputDecoration(
            hintText: 'Enter your last name',
            icon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: 7.0),
        TextFormField(
          controller: phoneNoController,
          decoration: const InputDecoration(
            hintText: 'Enter your phone number',
            icon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            LengthLimitingTextInputFormatter(10),
          ],
        ),
        SizedBox(height: 7.0),
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            hintText: 'Enter your email address',
            icon: Icon(Icons.email),
          ),
        ),
        SizedBox(height: 7.0),
        TextFormField(
          controller: passwordController,
          obscureText: _isObscure,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            icon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 7.0),
        TextFormField(
          controller: confirmPasswordController,
          obscureText: _isConfirmObscure,
          decoration: InputDecoration(
            hintText: 'Confirm your password',
            icon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmObscure ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmObscure = !_isConfirmObscure;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 0),
        if (_showError)
          SizedBox(
            height: 10,
            child: ToastMessage(
              message: 'Please fill all fields',
              backgroundColor: Colors.red,
            ),
          )
        else
          SizedBox(height: 0),
        if (_showPasswordMatchError)
          SizedBox(
            height: 10,
            child: ToastMessage(
              message: 'Passwords do not match',
              backgroundColor: Colors.red,
            ),
          )
        else
          SizedBox(height: 0),
        if (_showWeakPasswordError)
          SizedBox(
            height: 10,
            child: ToastMessage(
              message: 'Password must be at least 8 characters long',
              backgroundColor: Colors.red,
            ),
          )
        else
          SizedBox(height: 0),
        if (_showEmailExistsError)
          SizedBox(
            height: 10,
            child: ToastMessage(
              message: 'Email already exists',
              backgroundColor: Colors.red,
            ),
          )
        else
          SizedBox(height: 0),
        if (_showEmailFormatError)
          SizedBox(
            height: 10,
            child: ToastMessage(
              message: 'Invalid email format',
              backgroundColor: Colors.red,
            ),
          )
        else
          SizedBox(height: 0),
        if (_showPhoneNumberFormatError)
          SizedBox(
            height: 10,
            child: ToastMessage(
              message:
                  'Please enter a valid phone number starting with 07 and having 10 digits only',
              backgroundColor: Colors.red,
            ),
          )
        else
          SizedBox(height: 0),
      ],
    );
  }

  void registerUser() async {
    Customer customer = Customer(
      1,
      firstNameController.text.trim(),
      lastNameController.text.trim(),
      phoneNoController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    try {
      final url = API.registration;

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(customer.toJson()),
      );

      final responseData = jsonDecode(response.body);

      print('URL: $url');

      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('firstName', firstNameController.text.trim());
          preferences.setString('lastName', lastNameController.text.trim());
          preferences.setString('phoneNo', phoneNoController.text.trim());
          preferences.setString('email', emailController.text.trim());

          // Registration successful, show toast message
          Fluttertoast.showToast(
            msg: 'Registration successful!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          // Navigate to login screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LoginPage(email: emailController.text.trim()),
            ),
            (route) => false,
          );
        } else {
          setState(() {
            _showError = false;
            _showPasswordMatchError = false;
            _showWeakPasswordError = false;
            _showEmailFormatError = false;
            _showPhoneNumberFormatError = false;
            _showEmailExistsError = true;
          });
        }
      } else {
        throw Exception(
            'Failed to register user. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Exception occurred: $error');
      Fluttertoast.showToast(
        msg: 'Failed to register user. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
