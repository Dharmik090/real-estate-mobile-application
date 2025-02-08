import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application/components/DrawerComponent.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../components/MyInputComponent.dart';
import '../components/MyAppBar.dart';

class AddProperty extends StatefulWidget {
  final bool isDarkTheme;
  final VoidCallback onThemeChange;

  const AddProperty(
      {super.key, required this.isDarkTheme, required this.onThemeChange});

  @override
  _AddPropertyState createState() => _AddPropertyState();
}

class _AddPropertyState extends State<AddProperty> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFiles; // Holds the selected image files

  @override
  void initState() {
    super.initState();
    _isLoggedIn();
    _imageFiles = []; // Initialize the image files list
  }

  void _isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');

    if (userId == '') {
      Navigator.pop(context, false);
      Navigator.pushNamed(context, '/login');
    }
  }

  String _titleValidate = '';
  String _descriptionValidate = '';
  String _priceValidate = '';
  String _bhkValidate = '';
  String _areaValidate = '';
  String _statusValidate = '';
  String _locationValidate = '';
  String _cityValidate = '';
  String _stateValidate = '';
  String _countryValidate = '';

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _bhkController = TextEditingController();
  final _areaController = TextEditingController();
  final _statusController = TextEditingController();
  final _locationController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();

  Future<void> _pickImages() async {
    final List<XFile>? selectedImages =
        await _picker.pickMultiImage(imageQuality: 80);
    if (selectedImages != null) {
      setState(() {
        _imageFiles = selectedImages; // Store selected images
      });
    }
  }

  void _addProperty() async {
    setState(() {
      _titleValidate = _titleController.text.isEmpty ? 'Enter some text' : '';
      _descriptionValidate =
          _descriptionController.text.isEmpty ? 'Enter some text' : '';
      _priceValidate = _priceController.text.isEmpty ? 'Enter some text' : '';
      _bhkValidate = _bhkController.text.isEmpty ? 'Enter some text' : '';
      _areaValidate = _areaController.text.isEmpty ? 'Enter some text' : '';
      _statusValidate = _statusController.text.isEmpty ? 'Enter some text' : '';
      _locationValidate =
          _locationController.text.isEmpty ? 'Enter some text' : '';
      _cityValidate = _cityController.text.isEmpty ? 'Enter some text' : '';
      _stateValidate = _stateController.text.isEmpty ? 'Enter some text' : '';
      _countryValidate =
          _countryController.text.isEmpty ? 'Enter some text' : '';
    });

    if (_descriptionValidate.isNotEmpty ||
        _priceValidate.isNotEmpty ||
        _bhkValidate.isNotEmpty ||
        _areaValidate.isNotEmpty ||
        _statusValidate.isNotEmpty ||
        _locationValidate.isNotEmpty ||
        _cityValidate.isNotEmpty ||
        _stateValidate.isNotEmpty ||
        _countryValidate.isNotEmpty) {
      return;
    }

    // REST API:
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    final String? token = prefs.getString('token');

    // final String url = /*your api url*/ + userId!;
    final String url = /*your api url*/ + userId!;

    // Prepare the property document
    // final Map<String, dynamic> propertyDocument = {
    //   'title': _titleController.text,
    //   'description': _descriptionController.text,
    //   'price': _priceController.text,
    //   'bhk': _bhkController.text,
    //   'area': _areaController.text,
    //   'status': _statusController.text,
    //   'location': _locationController.text,
    //   'city': _cityController.text,
    //   'state': _stateController.text,
    //   'country': _countryController.text,
    //   'images': []
    // };
    //
    // // Add images to the request
    // if (_imageFiles != null && _imageFiles!.isNotEmpty) {
    //   for (var imageFile in _imageFiles!) {
    //     final bytes = await imageFile.readAsBytes();
    //     String base64Image = base64Encode(bytes);
    //     propertyDocument['images'].add(base64Image);
    //   }
    // }

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll({
      "Authorization": "Bearer ${token}",
      "Content-Type": "multipart/form-data"
    });

    request.fields['title'] = _titleController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['price'] = _priceController.text;
    request.fields['bhk'] = _bhkController.text;
    request.fields['area'] = _areaController.text;
    request.fields['status'] = _statusController.text;
    request.fields['location'] = _locationController.text;
    request.fields['city'] = _cityController.text;
    request.fields['state'] = _stateController.text;
    request.fields['country'] = _countryController.text;

    for (var imageFile in _imageFiles!) {
      request.files.add(await http.MultipartFile.fromPath(
        'images',
        imageFile.path,
      ));
    }


    try {
      final response = await request.send();
      // final response = await http.post(Uri.parse(url),
      //     headers: {
      //       "Authorization": "Bearer ${token}",
      //       "Content-Type": "application/json"
      //     },
      //     body: jsonEncode(propertyDocument));

      final data = await response.stream.bytesToString();
      final message = jsonDecode(data)['message'];

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, false);
        Navigator.pushNamed(context, '/profile');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Add Property',
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
                  fieldController: _titleController,
                  fieldType: TextInputType.text,
                  fieldLable: 'Title',
                  error: _titleValidate,
                  isDarkTheme: widget.isDarkTheme,
                  onThemeChange: widget.onThemeChange,
                ),
                SizedBox(height: 20),
                MyInputComponent(
                  fieldController: _descriptionController,
                  fieldType: TextInputType.text,
                  fieldLable: 'Description',
                  error: _descriptionValidate,
                  isDarkTheme: widget.isDarkTheme,
                  onThemeChange: widget.onThemeChange,
                ),
                SizedBox(height: 20),
                MyInputComponent(
                  fieldController: _priceController,
                  fieldType: TextInputType.number,
                  fieldLable: 'Price',
                  error: _priceValidate,
                  isDarkTheme: widget.isDarkTheme,
                  onThemeChange: widget.onThemeChange,
                ),
                SizedBox(height: 20),
                MyInputComponent(
                  fieldController: _bhkController,
                  fieldType: TextInputType.number,
                  fieldLable: 'BHK',
                  error: _bhkValidate,
                  isDarkTheme: widget.isDarkTheme,
                  onThemeChange: widget.onThemeChange,
                ),
                SizedBox(height: 20),
                MyInputComponent(
                  fieldController: _areaController,
                  fieldType: TextInputType.number,
                  fieldLable: 'Area',
                  error: _areaValidate,
                  isDarkTheme: widget.isDarkTheme,
                  onThemeChange: widget.onThemeChange,
                ),
                SizedBox(height: 20),
                MyInputComponent(
                  fieldController: _statusController,
                  fieldType: TextInputType.text,
                  fieldLable: 'Status',
                  error: _statusValidate,
                  isDarkTheme: widget.isDarkTheme,
                  onThemeChange: widget.onThemeChange,
                ),
                SizedBox(height: 20),
                MyInputComponent(
                  fieldController: _locationController,
                  fieldType: TextInputType.text,
                  fieldLable: 'Location',
                  error: _locationValidate,
                  isDarkTheme: widget.isDarkTheme,
                  onThemeChange: widget.onThemeChange,
                ),
                SizedBox(height: 20),
                MyInputComponent(
                  fieldController: _cityController,
                  fieldType: TextInputType.text,
                  fieldLable: 'City',
                  error: _cityValidate,
                  isDarkTheme: widget.isDarkTheme,
                  onThemeChange: widget.onThemeChange,
                ),
                SizedBox(height: 20),
                MyInputComponent(
                  fieldController: _stateController,
                  fieldType: TextInputType.text,
                  fieldLable: 'State',
                  error: _stateValidate,
                  isDarkTheme: widget.isDarkTheme,
                  onThemeChange: widget.onThemeChange,
                ),
                SizedBox(height: 20),
                MyInputComponent(
                  fieldController: _countryController,
                  fieldType: TextInputType.text,
                  fieldLable: 'Country',
                  error: _countryValidate,
                  isDarkTheme: widget.isDarkTheme,
                  onThemeChange: widget.onThemeChange,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImages,
                  child: Text('Select Images'),
                ),
                SizedBox(height: 20),
                // Display selected images
                _imageFiles != null && _imageFiles!.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                        ),
                        itemCount: _imageFiles!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.file(
                              File(_imageFiles![index].path),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      )
                    : Container(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addProperty,
                  child: Text('Add Property'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
