// import 'package:flutter/material.dart';
//
// class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final bool leading;
//   final bool isDarkTheme;
//   final VoidCallback onThemeChange;
//
//   const MyAppBar(
//       {super.key,
//       required this.title,
//       required this.leading,
//       required this.isDarkTheme,
//       required this.onThemeChange});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text(title),
//       leading: leading
//           ? IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () => Navigator.pop(context, false),
//             )
//           : null,
//       centerTitle: true,
//       backgroundColor: Colors.teal,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           bottom: Radius.circular(16),
//         ),
//       ),
//       actions: [
//         ElevatedButton.icon(
//             onPressed: onThemeChange,
//             label: isDarkTheme
//                 ? const Text('Light Mode',
//                     style: TextStyle(color: Colors.white))
//                 : const Text('Dark Mode',
//                     style: TextStyle(color: Colors.black)))
//       ],
//     );
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // For formatting date and time

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool leading;
  final bool isDarkTheme;
  final VoidCallback onThemeChange;

  const MyAppBar(
      {super.key,
        required this.title,
        required this.leading,
        required this.isDarkTheme,
        required this.onThemeChange});

  @override
  Widget build(BuildContext context) {
    // Get the current date and time
    String formattedDateTime = DateFormat('EEE, MMM d, yyyy h:mm a').format(DateTime.now());

    return AppBar(
      title: Column(
        children: [
          Text(title),
          SizedBox(height: 4),
          Text(
            formattedDateTime,  // Display the current date and time
            style: TextStyle(fontSize: 14, color: isDarkTheme ? Colors.white : Colors.black),
          ),
        ],
      ),
      leading: leading
          ? IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context, false),
      )
          : null,
      centerTitle: true,
      backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.teal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      actions: [
        // Make the button smaller using a TextButton
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextButton.icon(
            onPressed: onThemeChange,
            icon: Icon(
              isDarkTheme ? Icons.light_mode : Icons.dark_mode,
              size: 18,
              color: isDarkTheme ? Colors.white : Colors.black
            ),
            label: Text(
              isDarkTheme ? 'Light' : 'Dark',
              style: TextStyle(fontSize: 12, color: isDarkTheme ? Colors.white : Colors.black)
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
