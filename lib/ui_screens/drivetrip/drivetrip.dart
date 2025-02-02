import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DriveTrip extends StatefulWidget {
  const DriveTrip({super.key});

  @override
  State<DriveTrip> createState() => _DriveTripState();
}

class _DriveTripState extends State<DriveTrip> {
  // Sample trip history data (Replace with real logged trips)
  final List<Map<String, dynamic>> tripHistory = [
    {"dateTime": DateTime.now().subtract(Duration(days: 1))},
    {"dateTime": DateTime.now().subtract(Duration(days: 2))},
    {"dateTime": DateTime.now().subtract(Duration(days: 3))},
    {"dateTime": DateTime.now().subtract(Duration(days: 4))},
    {"dateTime": DateTime.now().subtract(Duration(days: 5))},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple, // Changed background to Deep Purple
      appBar: AppBar(
        title: const Text("Trip History"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: tripHistory.length,
          itemBuilder: (context, index) {
            final trip = tripHistory[index];
            String formattedDate =
                DateFormat('yyyy-MM-dd HH:mm').format(trip["dateTime"]);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TripDetailsScreen(tripDateTime: trip["dateTime"]),
                  ),
                );
              },
              child: Card(
                color: Colors.deepPurple[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.directions_car, color: Colors.deepPurple),
                  ),
                  title: Text(
                    "Trip on $formattedDate",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 18, color: Colors.yellowAccent[700]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Dummy Trip Details Page (Modify to show real details)
class TripDetailsScreen extends StatelessWidget {
  final DateTime tripDateTime;

  const TripDetailsScreen({super.key, required this.tripDateTime});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(tripDateTime);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Details"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Text(
          "Details of trip on $formattedDate",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
