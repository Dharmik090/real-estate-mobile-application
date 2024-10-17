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
  late final List<dynamic> homes;
  @override
  void initState() async {
    super.initState();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');

    final url = "http://localhost:5000/property/" + username!;
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
