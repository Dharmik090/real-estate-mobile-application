import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/components/DrawerComponent.dart';
import 'package:flutter_application/screens/AddProperty.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/MyAppBar.dart';
import '../models/Property.dart';
import '../components/PropertyCard.dart';

class MyProperties extends StatefulWidget {

  final bool isDarkTheme;
  final VoidCallback onThemeChange;

  const MyProperties({super.key,required this.isDarkTheme,required this.onThemeChange});

  @override
  _MyPropertiesState createState() => _MyPropertiesState();
}

class _MyPropertiesState extends State<MyProperties> {
  List<dynamic> homes = [];
  @override
  void initState() {
    super.initState();
    fetchProperties();
  }


  Future<void> fetchProperties() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    final String? token = prefs.getString('token');

    final String apiUrl = "http://10.0.2.2:5000/user/property/${userId}";
    // final String url = "http://192.168.1.11:5000/user/property/${userId}";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      // Check for successful response
      if (response.statusCode == 200) {
        final body = response.body;

        // Check if body is empty or null
        if (body.isEmpty) {
          throw Exception('Empty response body');
        }

        final List<dynamic> data = jsonDecode(body);


        setState(() {
          homes = (data as List)?.map((json) => Property.fromJson(json))?.toList() ?? [];
        });
      } else {
        throw Exception('Failed to load properties, status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
      });
      print('Error fetching properties: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Estate Ease',
        leading: false,
        isDarkTheme: widget.isDarkTheme,
        onThemeChange: widget.onThemeChange,
      ),
      drawer: DrawerComponent(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: homes.length,
          itemBuilder: (context, index) {
            final home = homes[index];
            return PropertyCard(
              property: home,
              isDarkTheme: widget.isDarkTheme,
              onThemeChange: widget.onThemeChange,
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Property',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddProperty(
                      isDarkTheme: widget.isDarkTheme, onThemeChange: widget.onThemeChange)),
            );
          }
        },
      ),
    );
  }
}
