import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/screens/AddProperty.dart';
import 'package:flutter_application/screens/MyProperties.dart';
import 'package:flutter_application/screens/Profile.dart';
import 'package:flutter_application/screens/Home.dart';
import 'package:flutter_application/screens/PropertyDetails.dart';
import 'package:flutter_application/screens/LogIn.dart';
import 'package:flutter_application/screens/SignUp.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
   _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;

  @override
  void initState(){
    super.initState();

    DateTime current = DateTime.now();
    if(current.hour >= 6 && current.hour < 18)
      _isDarkTheme = false;
    else
      _isDarkTheme = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      routes: {
        '/': (context) => HomeScreen(isDarkTheme: _isDarkTheme, onThemeChange: _toggleTheme),
        '/profile': (context) => Profile(isDarkTheme: _isDarkTheme, onThemeChange: _toggleTheme),
        '/details': (context) => PropertyDetails(isDarkTheme: _isDarkTheme, onThemeChange: _toggleTheme),
        '/user/properties': (context) => MyProperties(isDarkTheme: _isDarkTheme, onThemeChange: _toggleTheme),
        '/property/add': (context) => AddProperty(isDarkTheme: _isDarkTheme, onThemeChange: _toggleTheme),
        '/signup': (context) => SignUp(isDarkTheme: _isDarkTheme, onThemeChange: _toggleTheme),
        '/login': (context) => LogIn(isDarkTheme: _isDarkTheme, onThemeChange: _toggleTheme),
        '/logout': (context) => LogIn(isDarkTheme: _isDarkTheme, onThemeChange: _toggleTheme)
      },
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      // home: HomeScreen(
      //   isDarkTheme: _isDarkTheme,
      //   onThemeChange: _toggleTheme,
      // ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }
}
