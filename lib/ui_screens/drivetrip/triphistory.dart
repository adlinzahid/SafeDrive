import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:safe_drive/ui_screens/drivetrip/drivesummary.dart';

class TripDetails extends StatefulWidget {
  final DateTime tripDateTime;

  const TripDetails({super.key, required this.tripDateTime});

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  final LatLng _startLocation =
      const LatLng(3.1390, 101.6869); // Example start location
  final LatLng _endLocation =
      const LatLng(3.1500, 101.7000); // Example end location
  final MapController _mapController = MapController();

  double totalDistance = 5.2; // Mock distance in KM
  double avgSpeed = 45.3; // Mock speed in KM/h
  int hardBrakes = 2; // Mock hard brake count
  int sharpTurns = 3; // Mock sharp turn count
  int suddenAccelerations = 1; // Mock sudden acceleration count

  String getFeedback() {
    if (hardBrakes == 0 && sharpTurns == 0 && suddenAccelerations == 0) {
      return "Great job! Your driving was smooth and safe.";
    } else if (hardBrakes > 0) {
      return "You hit hard brakes $hardBrakes time(s). Maintain a safe distance!";
    } else if (sharpTurns > 0) {
      return "You made $sharpTurns sharp turn(s). Try to plan your turns earlier!";
    } else if (suddenAccelerations > 0) {
      return "You had $suddenAccelerations sudden acceleration(s). Drive more smoothly!";
    } else {
      return "Drive with caution!";
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm').format(widget.tripDateTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Details"),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.deepPurple, // Set the background color to purple
        child: Column(
          children: [
            // OpenStreetMap Section
            Container(
              width: double.infinity,
              height: 300,
              padding: const EdgeInsets.all(10),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _startLocation,
                  initialZoom: 14.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _startLocation,
                        child: const Icon(
                          Icons.circle,
                          color: Colors.green,
                          size: 40.0,
                        ),
                      ),
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _endLocation,
                        child: const Icon(
                          Icons.circle,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    ],
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [_startLocation, _endLocation],
                        strokeWidth: 4.0,
                        color: Colors.deepPurple,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Trip Details Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trip Date/Time
                  Center(
                    child: Text(
                      "Trip on $formattedDate",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Trip Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTripStat("Distance", "$totalDistance km"),
                      _buildTripStat("Avg Speed", "$avgSpeed km/h"),
                    ],
                  ),
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTripStat("Hard Brakes", "$hardBrakes times"),
                      _buildTripStat("Sharp Turns", "$sharpTurns turns"),
                    ],
                  ),
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTripStat(
                          "Sudden Accelerations", "$suddenAccelerations times"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Feedback message
                  Center(
                    child: Text(
                      getFeedback(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DriveTrip()), // Navigate to the trip summary screen
                      );
                    },
                    child: Text("Trip Summary"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripStat(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}
