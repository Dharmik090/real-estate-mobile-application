import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/components/DrawerComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/MyAppBar.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  final bool isDarkTheme;
  final VoidCallback onThemeChange;

  const Profile(
      {super.key, required this.isDarkTheme, required this.onThemeChange});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? _userData;
  List<dynamic> _userProperties = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    final String? token = prefs.getString('token');

    final String url = /*your api url*/ + userId;

    final String propertiesUrl =
        /*your api url*/ + userId; // Assuming this API gives user properties

    try {
      // Fetch user data
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      // Fetch user properties
      final propertiesResponse = await http.get(
        Uri.parse(propertiesUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200 && propertiesResponse.statusCode == 200) {
        final user = jsonDecode(response.body);
        final userProperties = jsonDecode(propertiesResponse.body);

        setState(() {
          _userData = user;
          _userProperties = userProperties;
          _isLoading = false;
        });
      } else {
        final message = jsonDecode(response.body)["message"];
        setState(() {
          _errorMessage = message;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 10),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
          duration: Duration(seconds: 10),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteProperty(String propertyId) async {
    final String url = /*your api url*/ + propertyId;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final message = jsonDecode(response.body)['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );
        _fetchUserDetails(); // Refresh the user details and properties list after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete the property"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          title: 'Profile',
          leading: true,
          isDarkTheme: widget.isDarkTheme,
          onThemeChange: widget.onThemeChange),
      drawer: DrawerComponent(),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show a loading indicator while fetching data
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Details',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: MemoryImage(base64Decode(
                                          _userData!['avatar'].split(',')[1]))),
                                ),
                                SizedBox(height: 10),
                                Text(
                                    'Name: ${_userData!['firstname']} ${_userData!['lastname']}',
                                    style: TextStyle(fontSize: 18)),
                                SizedBox(height: 10),
                                Text('Username: ${_userData!['username']}',
                                    style: TextStyle(fontSize: 18)),
                                SizedBox(height: 10),
                                Text('Email: ${_userData!['email']}',
                                    style: TextStyle(fontSize: 18)),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/user/update');
                                  },
                                  child: Text('Update Profile'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Your Properties',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        _userProperties.isEmpty
                            ? Text('No properties')
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _userProperties.length,
                                itemBuilder: (context, index) {
                                  final property = _userProperties[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: ListTile(
                                      title: Text(property['title']),
                                      subtitle:
                                          Text('Price: ${property['price']}'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/propert/update',
                                                arguments: property,
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () => _deleteProperty(
                                                property['_id']),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/property/add');
                          },
                          child: Text('Add New Property'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
