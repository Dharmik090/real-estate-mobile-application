import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/components/DrawerComponent.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../components/MyAppBar.dart';
import '../components/MyInputComponent.dart';

class LogIn extends StatefulWidget {
  final bool isDarkTheme;
  final VoidCallback onThemeChange;

  const LogIn(
      {super.key, required this.isDarkTheme, required this.onThemeChange});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String _emailValidate = '';
  String _passwordValidate = '';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signIn() async {
    // is Empty :
    setState(() {
      _emailValidate =
          _emailController.text.isEmpty ? 'Email can not be empty' : '';
      _passwordValidate =
          _passwordController.text.isEmpty ? 'Password can not be empty' : '';
    });

    if (_emailValidate.length != 0 || _passwordValidate.length != 0) return;

    final String url = "http://10.0.2.2:5000/login/";
    // final String url = "http://192.168.1.11:5000/login/";

    Map<String, dynamic> loginData = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(loginData));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', data['token']);
        await prefs.setString('userId', data['userId']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signin Successfull'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushNamed(context, '/');
      } else {
        final message = data['message'];
        setState(() {
          if (message == 'Email does not exist') {
            _emailValidate = message;
          } else {
            _passwordValidate = message;
          }
        });
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Login',
        leading: true,
        isDarkTheme: widget.isDarkTheme,
        onThemeChange: widget.onThemeChange,
      ),
      drawer: DrawerComponent(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyInputComponent(
                    fieldController: _emailController,
                    fieldType: TextInputType.emailAddress,
                    fieldLable: 'Email',
                    error: _emailValidate,
                    isDarkTheme: widget.isDarkTheme,
                    onThemeChange: widget.onThemeChange),
                SizedBox(height: 20),
                MyInputComponent(
                    fieldController: _passwordController,
                    fieldType: TextInputType.text,
                    fieldLable: 'Password',
                    error: _passwordValidate,
                    isDarkTheme: widget.isDarkTheme,
                    onThemeChange: widget.onThemeChange),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text('Don\'t have an account? Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
