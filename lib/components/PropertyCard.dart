import 'package:flutter/material.dart';
import '../models/Property.dart';
import 'dart:convert';
import 'dart:typed_data';


class PropertyCard extends StatelessWidget {
  final Property property;
  final bool isDarkTheme;
  final VoidCallback onThemeChange;


  const PropertyCard({super.key,
    required this.property,
    required this.isDarkTheme,
    required this.onThemeChange
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/details',
            arguments: property
          );
        },
        child: Card(
          color: isDarkTheme ? Colors.black.withOpacity(1) : Colors.white.withOpacity(1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: property.imageUrls.isNotEmpty
                      ? _buildImage(property.imageUrls[0]) // First image
                      : const SizedBox(
                    height: 200,
                    child: Center(child: Text('No Image Available')),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  property.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  property.country,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  property.price.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.teal[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }



  Widget _buildImage(String base64Image) {
    try {
      String base64String = base64Image.split(',').last;

      Uint8List decodedBytes = base64Decode(base64String);

      return Image.memory(
        decodedBytes,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    } catch (e) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Error loading image')),
      );
    }
  }
}


