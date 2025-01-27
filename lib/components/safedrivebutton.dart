import 'package:flutter/material.dart';

//this is a custom button widget that can be used in any screen

class Safedrivebutton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  const Safedrivebutton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 35.0),
        decoration: BoxDecoration(
            color: Colors.yellowAccent[700],
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.deepPurpleAccent,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w800,
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}
