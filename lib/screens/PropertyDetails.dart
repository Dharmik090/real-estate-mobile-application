import 'package:flutter/material.dart';
import 'package:flutter_application/components/DrawerComponent.dart';
import '../models/Property.dart';
import '../components/MyAppBar.dart';

class PropertyDetails extends StatelessWidget{
  final bool isDarkTheme;
  final VoidCallback onThemeChange;


  const PropertyDetails({super.key,
    required this.isDarkTheme,
    required this.onThemeChange
  });

  @override
  Widget build(BuildContext context){
    final Property property = ModalRoute.of(context)!.settings.arguments as Property;

    return Scaffold(
      appBar: MyAppBar(
        title: 'Estate Ease',
        isDarkTheme: isDarkTheme,
        onThemeChange: onThemeChange,
        leading: true
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image(
                image: AssetImage(property.imageUrls[0]),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
              ),
            ),
            const SizedBox(height: 16),
            Text(
             property.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              property.location,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              property.price as String,
              style: TextStyle(
                fontSize: 22,
                color: Colors.teal[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            // Add more details here if needed
          ],
        ),
      ),
    );
  }
}