import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerComponent extends StatefulWidget {
  const DrawerComponent({super.key});

  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    // Check if the user is logged in when the widget is initialized
    isLoggedIn();
  }

  Future<void> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

      setState(() {
        if(userId != '')
          _isLoggedIn = true;
        else
        _isLoggedIn = false;
      });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', ''); // Save user ID in shared preferences
    await prefs.setString('token', ''); // Save user ID in shared preferences

    setState(() {
      _isLoggedIn = false;  // Update the login status after logging out
    });
    Navigator.pushNamed(context, '/login');  // Redirect to login page
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: 200,
        child: ListView(
          children: [
            ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.pushNamed(context, '/');
                }
            ),
            if (!_isLoggedIn) ...[
              ListTile(
                title: const Text('Signup'),
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                },
              ),
              ListTile(
                title: const Text('Login'),
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ] else ...[
              ListTile(
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  }
              ),
              ListTile(
                title: const Text('My Properties'),
                onTap: (){
                  Navigator.pushNamed(context, '/user/properties');
                }
              ),
              ListTile(
                title: const Text('Logout'),
                onTap: _logout,
              ),
            ],
          ],
        )
    );
  }
}

