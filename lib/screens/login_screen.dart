import 'package:flutter/material.dart';
import 'package:pharmacyApp/common_widgets/app_button.dart';
import 'package:pharmacyApp/common_widgets/register_link.dart';
import 'package:pharmacyApp/screens/register_screen.dart';
import 'package:pharmacyApp/screens/dashboard/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showError = false;
  bool _noUserError = false;
  bool _showWrongPasswordError = false;
  bool _showEmailFormatError = false;
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool _isObscure = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loadSavedCredentials();
    super.initState();
  }

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    if (email != null) {
      _emailController.text = email;
    }
    if (password != null) {
      _passwordController.text = password;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                      _showError
                          ? Text('Please fill all fields',
                              style: TextStyle(color: Colors.red))
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _noUserError
                          ? Text(
                              'User does not exist',
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      _showWrongPasswordError
                          ? Text(
                              'Wrong password',
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
                            onLoginClicked(context);
                          }
                        },
                      ),
                      RegisterLink(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationPage()));
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

  void onLoginClicked(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => DashboardScreen(),
        ));
      }
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('email', _emailController.text.trim());
      prefs.setString('password', _passwordController.text.trim());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          bool loginSuccessful = true;
          return AlertDialog(
            // ignore: dead_code
            title: Text(loginSuccessful ? "Login Successful" : "Login Failed"),
            content: Text(loginSuccessful
                ? "You have successfully logged in!"
                // ignore: dead_code
                : "Sorry, login failed. Please try again."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return DashboardScreen();
                    },
                  ));
                },
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _noUserError = true;
          _showWrongPasswordError = false;
          _showError = false;
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _showWrongPasswordError = true;
          _noUserError = false;
          _showError = false;
        });
      } else if (!_emailRegex.hasMatch(_emailController.text)) {
        setState(() {
          _showError = false;
          _showWrongPasswordError = false;
          _noUserError = false;
          _showError = false;
          _showEmailFormatError = true;
        });
      } else {
        setState(() {
          _showError = false;
          _noUserError = false;
          _showWrongPasswordError = false;
        });
      }
    }
  }
}
