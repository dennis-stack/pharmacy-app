import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacyApp/connection/connection.dart';
import 'package:pharmacyApp/common_widgets/app_button.dart';
import 'package:pharmacyApp/common_widgets/register_link.dart';
import 'package:pharmacyApp/common_widgets/toast_message.dart';
import 'package:pharmacyApp/screens/register_screen.dart';
import 'package:pharmacyApp/screens/dashboard/dashboard_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final String email;

  const LoginPage({Key? key, required this.email}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _showError = false;
  bool _noUserError = false;
  bool _showWrongPasswordError = false;
  bool _showEmailFormatError = false;
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool _isObscure = true;

  @override
  void initState() {
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController();
    loadSavedCredentials();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      _emailController.text = email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
                        height: 420,
                      ),
                      textField(),
                      SizedBox(
                        height: 5,
                      ),
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
                      if (_noUserError)
                        SizedBox(
                          height: 10,
                          child: ToastMessage(
                            message: 'User does not exist',
                            backgroundColor: Colors.red,
                          ),
                        )
                      else
                        SizedBox(height: 0),
                      if (_showWrongPasswordError)
                        SizedBox(
                          height: 10,
                          child: ToastMessage(
                            message: 'Wrong Password',
                            backgroundColor: Colors.red,
                          ),
                        )
                      else
                        SizedBox(height: 0),
                      if (_showEmailFormatError)
                        SizedBox(
                          height: 10,
                          child: ToastMessage(
                            message: 'Please enter a valid email address',
                            backgroundColor: Colors.red,
                          ),
                        )
                      else
                        SizedBox(height: 0),
                      SizedBox(
                        height: 10,
                      ),
                      AppButton(
                        label: 'Login',
                        onPressed: () {
                          if (_emailController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            setState(() {
                              _showError = true;
                              _noUserError = false;
                              _showWrongPasswordError = false;
                            });
                          } else {
                            login();
                          }
                        },
                      ),
                      RegisterLink(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationPage(),
                            ),
                          );
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
          controller: _emailController,
          decoration: const InputDecoration(
            hintText: 'Enter your email address',
            icon: Icon(Icons.email),
          ),
        ),
        SizedBox(
          height: 20.0,
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
          height: 20.0,
        ),
      ],
    );
  }

  void login() async {
    final url = API.login;
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final loginSuccessful = data['success'] ?? false;

      if (loginSuccessful) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('email', _emailController.text.trim());
        preferences.setString('password', _passwordController.text.trim());

        final user = data['user'];
        preferences.setString('firstName', user['firstName']);
        preferences.setString('lastName', user['lastName']);
        preferences.setString('phoneNo', user['phoneNo']);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => DashboardScreen(),
          ),
        );

        Fluttertoast.showToast(
          msg: 'Login successful!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        setState(() {
          _noUserError = data['error'] == 'user-not-found';
          _showWrongPasswordError = data['error'] == 'wrong-password';
          _showEmailFormatError = !_emailRegex.hasMatch(_emailController.text);
          _showError = false;
        });
      }
    } else {
      // Handle error
      print('Login request failed with status: ${response.statusCode}');
      if (response.statusCode == 503) {
        Fluttertoast.showToast(
          msg: "Server is currently offline",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to login. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }
}
