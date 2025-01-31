import 'package:flutter/material.dart';

class DriveTrip extends StatefulWidget {
  const DriveTrip({super.key});

  @override
  State<DriveTrip> createState() => _DriveTripState();
}

class _DriveTripState extends State<DriveTrip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: Text('Trip History',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 27,
                color: Colors.yellowAccent[700],
                letterSpacing: 1.5)),
        centerTitle: true,
      ),
    );
  }
}
