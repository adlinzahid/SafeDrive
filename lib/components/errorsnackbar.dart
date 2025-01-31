//this file is for the error snackbar to be displayed when an error occurs in SafeDrive

import 'package:flutter/material.dart';

class Errorsnackbar extends StatelessWidget {
  final String message;

  const Errorsnackbar({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(message,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w600)),
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      showCloseIcon: true,
    );
  }
}
