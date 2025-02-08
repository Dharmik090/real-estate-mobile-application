import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/components/DrawerComponent.dart';
import 'package:http/http.dart' as http;

import '../components/MyAppBar.dart';
import '../components/PropertyCard.dart';
import '../models/Property.dart';


class HomeScreen extends StatefulWidget {
  final bool isDarkTheme;
  final VoidCallback onThemeChange;

  HomeScreen({super.key, required this.isDarkTheme, required this.onThemeChange});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// class _HomeScreenState extends State<HomeScreen> {
class _HomeScreenState extends State<HomeScreen> {

  List<dynamic> homes = [];
  bool isLoading = true;
  String apiUrl = /*your api url*/;
  // final String apiUrl = /*your api url*/;

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {

    try {
      final response = await http.get(Uri.parse(apiUrl));

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
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load properties, status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
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
            Navigator.pushNamed(context,'/property/add');
          }
        },
      ),
    );
  }
}
