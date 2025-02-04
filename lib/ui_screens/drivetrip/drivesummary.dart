//displaying the trip history of the user

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DriveTrip extends StatefulWidget {
  const DriveTrip({super.key});

  @override
  State<DriveTrip> createState() => _DriveTripState();
}

class _DriveTripState extends State<DriveTrip> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: const Text(
          "Trip History",
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser!.uid)
            .collection("DriveTrips")
            .orderBy("startTime", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var trips = snapshot.data!.docs;
          if (trips.isEmpty) {
            return Center(
              child: Text(
                "No trip history available",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              var trip = trips[index];
              DateTime startTime = DateTime.parse(trip["startTime"]);
              String formattedDate =
                  DateFormat('yyyy-MM-dd HH:mm').format(startTime);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetails(tripId: trip.id),
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
                      child:
                          Icon(Icons.directions_car, color: Colors.deepPurple),
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
          );
        },
      ),
    );
  }
}

class TripDetails extends StatelessWidget {
  final String tripId;
  const TripDetails({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
          title: const Text("Trip Summary"),
          backgroundColor: Colors.deepPurple),
      backgroundColor: Colors.deepPurple,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser!.uid)
            .collection("DriveTrips")
            .doc(tripId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var trip = snapshot.data!.data() as Map<String, dynamic>;
          var route = (trip["route"] as List<dynamic>)
              .map((point) => LatLng(point["lat"], point["lng"]))
              .toList();

          return Column(
            children: [
              Text("Trip Duration: ${trip["startTime"]} - ${trip["endTime"]}",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              Text("Hard Brakes: ${trip["hardBrakes"]}",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              Text("Sharp Turns: ${trip["sharpTurns"]}",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              Text("Sudden Acceleration: ${trip["suddenAcceleration"]}",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              Text("Feedback: ${trip["feedbackMessage"]}",
                  style:
                      TextStyle(fontSize: 18, color: Colors.yellowAccent[700])),
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                      initialCenter: route.first, minZoom: 15.0, maxZoom: 18.0),
                  children: [
                    TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"),
                    PolylineLayer(polylines: [
                      Polyline(
                          points: route, strokeWidth: 4.0, color: Colors.blue)
                    ]),
                    MarkerLayer(markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: route.first,
                        child: const Icon(Icons.circle,
                            color: Colors.green, size: 40.0),
                      ),
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: route.last,
                        child: const Icon(Icons.circle,
                            color: Colors.red, size: 40.0),
                      ),
                    ]),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Back"),
              ),
            ],
          );
        },
      ),
    );
  }
}
