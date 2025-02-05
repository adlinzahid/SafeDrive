import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class TripDetails extends StatelessWidget {
  final DateTime startTime;
  static const LatLng defaultLocation =
      LatLng(3.2505289166651865, 101.73460979753958);
  //define end default location (lat, long)
  static const LatLng endLocation =
      LatLng(3.154113717077158, 101.71342266501364);

  const TripDetails({super.key, required this.startTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Details",
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.yellowAccent[700])),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.deepPurple,
      body: FutureBuilder(
        future: fetchTripDetails(startTime),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text(snapshot.error.toString(),
                    style: const TextStyle(
                        fontFamily: 'Montserrat', color: Colors.white)));
          }
          if (!snapshot.hasData ||
              snapshot.data == null ||
              (snapshot.data as List).isEmpty) {
            return const Center(
                child: Text("Trip data not found",
                    style: TextStyle(color: Colors.white)));
          }

          List<DocumentSnapshot> tripDocs =
              snapshot.data as List<DocumentSnapshot>;
          var tripData = tripDocs.first.data() as Map<String, dynamic>;
          var route = (tripData["route"] as List<dynamic>?)
                  ?.map((point) => LatLng(point["lat"], point["lng"]))
                  .toList() ??
              [defaultLocation, endLocation];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 250,
                  child: FlutterMap(
                    options: MapOptions(
                        initialCenter: route.first, minZoom: 12, maxZoom: 18),
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
                            point: route.first,
                            child: const Icon(Icons.location_on,
                                color: Colors.green, size: 40.0)),
                        Marker(
                            point: route.last,
                            child: const Icon(Icons.location_on,
                                color: Colors.red, size: 40.0)),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                    "Trip on ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(tripData["startTime"]))}",
                    style: const TextStyle(
                        color: Colors.yellow,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _infoTile("Distance", "${tripData["distance"]} km"),
                    //put space between the two tiles
                    const SizedBox(width: 10),
                    _infoTile("Avg Speed", "${tripData["avgSpeed"]} km/h"),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _infoTile("Hard Brakes", "${tripData["hardBrakes"]} times"),
                    //put space between the two tiles
                    const SizedBox(width: 10),
                    _infoTile("Sharp Turns", "${tripData["sharpTurns"]} turns"),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _infoTile("Sudden Accelerations",
                        "${tripData["suddenAcceleration"]} times"),
                  ],
                ),
                const SizedBox(height: 35),
                Container(
                  padding: const EdgeInsets.all(25.0),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent[700],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(tripData["feedbackMessage"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.deepPurple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Future<Object> fetchTripDetails(DateTime startTime) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Future.error('User is not authenticated');
    }
    QuerySnapshot userDoc = await FirebaseFirestore.instance
        .collection("Users")
        .where("uid", isEqualTo: user.uid)
        .limit(1)
        .get();
    if (userDoc.docs.isNotEmpty) {
      DocumentReference userRef = userDoc.docs.first.reference;
      QuerySnapshot tripDetails = await userRef
          .collection("DriveTrips")
          .where("startTime", isEqualTo: startTime.toIso8601String())
          .get();
      log('Trip details fetched: ${tripDetails.docs}');
      if (tripDetails.docs.isNotEmpty) {
        return tripDetails.docs;
      } else {
        return Future.error('No trip details found for the given startTime');
      }
    } else {
      return Future.error('User document not found');
    }
  }
}
