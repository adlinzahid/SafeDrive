import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:safe_drive/ui_screens/drivetrip/tripdetails.dart';

class DriveTrip extends StatefulWidget {
  const DriveTrip({super.key});

  @override
  State<DriveTrip> createState() => _DriveTripState();
}

class _DriveTripState extends State<DriveTrip> {
  final user = FirebaseAuth.instance.currentUser;
  String? uniqueId;
  //define default latitude and longitude
  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          title: Text(
            "Trip History",
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.yellowAccent[700]),
          ),
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: FutureBuilder<Object>(
                future: fetchDrives(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                    return const Center(
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

                  var trips = snapshot.data as List<DocumentSnapshot>;

                  return ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      var trip = trips[index];
                      DateTime startTime = DateTime.parse(trip["startTime"]);
                      String formattedDate =
                          DateFormat('yyyy-MM-dd HH:mm').format(startTime);

                      return GestureDetector(
                        onTap: () {
                          DateTime startTime =
                              DateTime.parse(trip["startTime"]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TripDetails(
                                  startTime: startTime), // Pass startTime
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
                              child: Icon(Icons.directions_car,
                                  color: Colors.deepPurple),
                            ),
                            title: Text(
                              "Trip on $formattedDate",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,
                                size: 18, color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )));
  }

  //fetch all drives of the user
  Future<Object> fetchDrives() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Future.error('User is not authenticated');
    }

    //query for the correct user document first
    QuerySnapshot userDoc = await FirebaseFirestore.instance
        .collection("Users")
        .where("uid", isEqualTo: user.uid)
        .limit(1)
        .get();

    if (userDoc.docs.isNotEmpty) {
      DocumentReference userRef = userDoc.docs.first.reference;

      //fetch all the drives of the user
      QuerySnapshot drives = await userRef.collection("DriveTrips").get();

      if (drives.docs.isNotEmpty) {
        return drives.docs;
      } else {
        return Future.error('No drives found for the user');
      }
    } else {
      return Future.error('User document not found');
    }
  }
}

// class TripDetails extends StatelessWidget {
//   const TripDetails({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       return const Scaffold(
//         body: Center(
//           child:
//               Text("User not logged in", style: TextStyle(color: Colors.white)),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Trip Summary",
//             style: TextStyle(
//                 fontFamily: 'Montserrat',
//                 color: Colors.yellowAccent[700],
//                 fontSize: 25,
//                 fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.deepPurple,
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.deepPurple,
//       body: FutureBuilder<QuerySnapshot>(
//         future: FirebaseFirestore.instance
//             .collection("Users")
//             .where("uid", isEqualTo: user.uid) // Find the correct user document
//             .limit(1)
//             .get(),
//         builder: (context, userSnapshot) {
//           if (userSnapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text("User document not found",
//                   style: TextStyle(color: Colors.white)),
//             );
//           }

//           // Get the user's document reference
//           DocumentReference userDoc = userSnapshot.data!.docs.first.reference;

//           return FutureBuilder<DocumentSnapshot>(
//             future: userDoc.collection("DriveTrips").doc().get(),
//             builder: (context, tripSnapshot) {
//               if (tripSnapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (!tripSnapshot.hasData || !tripSnapshot.data!.exists) {
//                 return const Center(
//                   child: Text("Trip data not found",
//                       style: TextStyle(color: Colors.white)),
//                 );
//               }

//               var tripData = tripSnapshot.data!.data() as Map<String, dynamic>;
//               var route = (tripData["route"] as List<dynamic>)
//                   .map((point) => LatLng(point["lat"], point["lng"]))
//                   .toList();

//               return Column(
//                 children: [
//                   Text(
//                       "Trip Duration: ${tripData["startTime"]} - ${tripData["endTime"]}",
//                       style:
//                           const TextStyle(fontSize: 18, color: Colors.white)),
//                   Text("Hard Brakes: ${tripData["hardBrakes"]}",
//                       style:
//                           const TextStyle(fontSize: 18, color: Colors.white)),
//                   Text("Sharp Turns: ${tripData["sharpTurns"]}",
//                       style:
//                           const TextStyle(fontSize: 18, color: Colors.white)),
//                   Text("Sudden Acceleration: ${tripData["suddenAcceleration"]}",
//                       style:
//                           const TextStyle(fontSize: 18, color: Colors.white)),
//                   Text("Feedback: ${tripData["feedbackMessage"]}",
//                       style: TextStyle(
//                           fontSize: 18, color: Colors.yellowAccent[700])),
//                   Expanded(
//                     child: FlutterMap(
//                       options: MapOptions(
//                         initialCenter: route.first,
//                         minZoom: 15.0,
//                         maxZoom: 18.0,
//                       ),
//                       children: [
//                         TileLayer(
//                           urlTemplate:
//                               "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                         ),
//                         PolylineLayer(polylines: [
//                           Polyline(
//                             points: route,
//                             strokeWidth: 4.0,
//                             color: Colors.blue,
//                           )
//                         ]),
//                         MarkerLayer(markers: [
//                           Marker(
//                             width: 80.0,
//                             height: 80.0,
//                             point: route.first,
//                             child: const Icon(Icons.circle,
//                                 color: Colors.green, size: 40.0),
//                           ),
//                           Marker(
//                             width: 80.0,
//                             height: 80.0,
//                             point: route.last,
//                             child: const Icon(Icons.circle,
//                                 color: Colors.red, size: 40.0),
//                           ),
//                         ]),
//                       ],
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text("Back"),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
