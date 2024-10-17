import 'package:flutter/material.dart';

class MyInputComponent extends StatelessWidget {
  final TextEditingController fieldController;
  final TextInputType fieldType;
  final String fieldLable;
  final String error;
  final bool isDarkTheme;
  final VoidCallback onThemeChange;

  const MyInputComponent(
      {super.key,
      required this.fieldController,
      required this.fieldType,
      required this.fieldLable,
      required this.error,
      required this.isDarkTheme,
      required this.onThemeChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: fieldController,
            decoration: InputDecoration(
                labelText: fieldLable,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black, width: 1.5),
                ),
                filled: true,
                fillColor: isDarkTheme ? Colors.grey[800] : Colors.white),
            keyboardType: fieldType,
          ),
        ),
        SizedBox(height: 8),
        Container(
            child: error.isNotEmpty
                ? Text(error,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ))
                : const SizedBox.shrink()),
        // SizedBox(height: 8)
      ],
    );
  }
}
