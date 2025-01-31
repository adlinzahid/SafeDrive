import 'package:flutter/material.dart';

// This is a custom textfield widget that can be used in any screen
// Modify the style of the textfield as needed here

class Safedrivetextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const Safedrivetextfield(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  State<Safedrivetextfield> createState() => _SafedrivetextfieldState();
}

class _SafedrivetextfieldState extends State<Safedrivetextfield> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(_focusNode);
        },
        child: TextField(
          focusNode: _focusNode,
          controller: widget.controller,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.deepPurple[200] ?? Colors.deepPurple,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.yellowAccent[700] ?? Colors.yellow,
              ),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.grey[600],
              fontFamily: 'Montserrat',
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
