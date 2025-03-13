import 'package:flutter/material.dart';

void showComingSoonSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Color(0xffeb6534), // Customize the background color
      behavior: SnackBarBehavior.floating, // Make it floating
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      duration: Duration(seconds: 2), // Display duration
    ),
  );
}