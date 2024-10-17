import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../components/DrawerComponent.dart';
import '../components/MyInputComponent.dart';
import '../components/MyAppBar.dart';

class SignUp extends StatefulWidget {
  final bool isDarkTheme;
  final VoidCallback onThemeChange;

  const SignUp({super.key, required this.isDarkTheme, required this.onThemeChange});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _firstnameValidate = '';
  String _lastnameValidate = '';
  String _usernameValidate = '';
  String _emailValidate = '';
  String _passwordValidate = '';

  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false; // Added to track loading state

  // Function to handle Sign Up logic
  void _signUp() async {
    // Validation check for each field
    setState(() {
      _firstnameValidate = _firstnameController.text.isEmpty ? 'First name cannot be empty' : '';
      _lastnameValidate = _lastnameController.text.isEmpty ? 'Last name cannot be empty' : '';
      _usernameValidate = _usernameController.text.isEmpty ? 'Username cannot be empty' : '';
      _emailValidate = _emailController.text.isEmpty ? 'Email cannot be empty' : '';
      _passwordValidate = _passwordController.text.isEmpty ? 'Password cannot be empty' : '';
    });

    // If any validation fails, return early
    if (_firstnameValidate.isNotEmpty ||
        _lastnameValidate.isNotEmpty ||
        _usernameValidate.isNotEmpty ||
        _emailValidate.isNotEmpty ||
        _passwordValidate.isNotEmpty) {
      return;
    }

    // Build user data from input fields
    final Map<String, dynamic> userDocument = {
      'firstname': _firstnameController.text,
      'lastname': _lastnameController.text,
      'email': _emailController.text,
      'username': _usernameController.text,
      'password': _passwordController.text,
    };

    // API endpoint URL
    // final String url = "http://10.0.2.2:5000/user";
    final String url = "http://192.168.1.11:5000/user";

    // Set loading state to true
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userDocument),
      );

      // Parse the response
      final String message = jsonDecode(response.body)['message'];

      if (response.statusCode == 201) {
        // Show success message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to home or login screen after success
        Navigator.pushNamed(context, '/');
      } else {
        // Handle specific errors from the response
        setState(() {
          if (message == 'Email already exist') {
            _emailValidate = message;
          } else if (message == 'Username already exist') {
            _usernameValidate = message;
          }
        });
      }
    } catch (err) {
      // Handle errors (e.g., no internet connection)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Set loading state to false
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Sign Up',
        leading: true,
        isDarkTheme: widget.isDarkTheme,
        onThemeChange: widget.onThemeChange,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyInputComponent(
                  fieldController: _firstnameController,
                  fieldType: TextInputType.text,
                  fieldLable: 'First Name',
                  error: _firstnameValidate,
                  isDarkTheme: widget.isDarkTheme,
                  onThemeChange: widget.onThemeChange,
                ),
                SizedBox(height: 20),
                MyInputComponent(
                  fieldController: _lastnameController,
                  fieldType: TextInputType.text,
                  fieldLable: 'Last Name',
                  error: _lastnameValidate,
                  isDarkTheme: widget.isDarkTheme,
                  onThemeChange: widget.onThemeChange,
                ),
                SizedBox(height: 20),
                MyInputComponent(
                  fieldController: _usernameController,
                  fieldType: TextInputType.text,
                  fieldLable: 'Username',
                  error: _usernameValidate,
                  isDarkTheme: widget.isDarkTheme,
                  onThemeChange: widget.onThemeChange,
                ),
                SizedBox(height: 20),
                MyInputComponent(
                  fieldController: _emailController,
                  fieldType: TextInputType.emailAddress,
                  fieldLable: 'Email',
                  error: _emailValidate,
                  isDarkTheme: widget.isDarkTheme,
                  onThemeChange: widget.onThemeChange,
                ),
                SizedBox(height: 20),
                MyInputComponent(
                  fieldController: _passwordController,
                  fieldType: TextInputType.text,
                  fieldLable: 'Password',
                  error: _passwordValidate,
                  isDarkTheme: widget.isDarkTheme,
                  onThemeChange: widget.onThemeChange,
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator() // Show loading indicator
                    : ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Signup'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
