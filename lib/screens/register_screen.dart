// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacyApp/common_widgets/app_button.dart';
import 'package:pharmacyApp/screens/login_screen.dart';
import 'package:pharmacyApp/common_widgets/login_link.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneNoController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _showError = false;
  bool _showPasswordMatchError = false;
  bool _showWeakPasswordError = false;
  bool _showEmailExistsError = false;
  bool _showEmailFormatError = false;
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool _showPhoneNumberFormatError = false;
  final _phoneNumberRegex = RegExp(r"^07\d{8}$");
  bool _isObscure = true;
  bool _isConfirmObscure = true;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNoController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Column(
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
                      //Icon(Icons.person),
                      SizedBox(
                        height: 250,
                      ),
                      textField(),
                      SizedBox(
                        height: 10,
                      ),
                      _showError
                          ? Text(
                              'Please fill all fields',
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _showPasswordMatchError
                          ? Text(
                              'Passwords do not match',
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _showWeakPasswordError
                          ? Text(
                              'Password should be at least 8 characters.',
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _showEmailExistsError
                          ? Text(
                              'An account already exists with this email.',
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _showEmailFormatError
                          ? Text(
                              'Please enter a valid email address.',
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _showPhoneNumberFormatError
                          ? Text(
                              'Please enter a valid phone number with the following format: 07XX-XXX-XXX.',
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
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
    );
  }

  Widget textField() {
    return Column(
      children: [
        TextField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              hintText: 'Enter your first name',
              icon: Icon(Icons.person),
            )),
        SizedBox(
          height: 7.0,
        ),
        TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              hintText: 'Enter your last name',
              icon: Icon(Icons.person),
            )),
        SizedBox(
          height: 7.0,
        ),
        TextField(
          controller: _phoneNoController,
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
        SizedBox(
          height: 7.0,
        ),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            hintText: 'Enter your email address',
            icon: Icon(Icons.email),
          ),
        ),
        SizedBox(
          height: 7.0,
        ),
        TextField(
          controller: _passwordController,
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
        SizedBox(
          height: 7.0,
        ),
        TextField(
          controller: _confirmPasswordController,
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
        SizedBox(
          height: 7.0,
        ),
        SizedBox(height: 20),
        AppButton(
          label: 'Register',
          onPressed: () {
            if (_firstNameController.text.isEmpty ||
                _lastNameController.text.isEmpty ||
                _phoneNoController.text.isEmpty ||
                _emailController.text.isEmpty ||
                _passwordController.text.isEmpty ||
                _confirmPasswordController.text.isEmpty) {
              setState(() {
                _showError = true;
                _showPasswordMatchError = false;
                _showWeakPasswordError = false;
                _showEmailExistsError = false;
                _showEmailFormatError = false;
                _showPhoneNumberFormatError = false;
              });
            } else if (_passwordController.text !=
                _confirmPasswordController.text) {
              setState(() {
                _showError = false;
                _showPasswordMatchError = true;
                _showWeakPasswordError = false;
                _showEmailExistsError = false;
                _showEmailFormatError = false;
                _showPhoneNumberFormatError = false;
              });
            } else if (_passwordController.text.length < 6) {
              setState(() {
                _showError = false;
                _showPasswordMatchError = false;
                _showWeakPasswordError = true;
                _showEmailExistsError = false;
                _showEmailFormatError = false;
                _showPhoneNumberFormatError = false;
              });
            } else if (!_emailRegex.hasMatch(_emailController.text)) {
              setState(() {
                _showError = false;
                _showPasswordMatchError = false;
                _showWeakPasswordError = false;
                _showEmailExistsError = false;
                _showPhoneNumberFormatError = false;
                _showEmailFormatError = true;
              });
            } else if (!_phoneNumberRegex.hasMatch(_phoneNoController.text)) {
              setState(() {
                _showError = false;
                _showPasswordMatchError = false;
                _showWeakPasswordError = false;
                _showEmailExistsError = false;
                _showEmailFormatError = false;
                _showPhoneNumberFormatError = true;
              });
            } else {
              setState(() {
                _showError = false;
                _showPasswordMatchError = false;
                _showWeakPasswordError = false;
                _showEmailExistsError = false;
                _showEmailFormatError = false;
                _showPhoneNumberFormatError = false;
              });
              _registerUser();
            }
          },
        ),
      ],
    );
  }

  void _registerUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        // create a reference to the 'users' collection
        CollectionReference usersRef =
            FirebaseFirestore.instance.collection('users');
        // set the user's data in the document
        await usersRef.doc(userCredential.user!.uid).set({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'phoneNo': _phoneNoController.text,
          'email': _emailController.text,
        });

        // show registration success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            bool registrationSuccessful = true;
            return AlertDialog(
              title: Text(registrationSuccessful
                  ? "Registration Successful"
                  : "Registration Failed"),
              content: Text(registrationSuccessful
                  ? "You have successfully registered!"
                  : "Sorry, registration failed. Please try again."),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return LoginPage();
                      },
                    ));
                  },
                ),
              ],
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          _showWeakPasswordError = true;
          _showError = false;
          _showPasswordMatchError = false;
          _showEmailExistsError = false;
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          _showEmailExistsError = true;
          _showError = false;
          _showPasswordMatchError = false;
          _showWeakPasswordError = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
