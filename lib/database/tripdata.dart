//user will stop the trip by clicking on the stop button and the trip data will be saved to firestore and deleted from real time database
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class TripData {
  final DatabaseReference _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://safedrive-f52ba-default-rtdb.asia-southeast1.firebasedatabase.app/",
  )
      .ref()
      .child("Users")
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child("ActiveTrip");

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void stopTrip() async {
    DataSnapshot snapshot = await _db.get();
    if (!snapshot.exists) return;

    Map<dynamic, dynamic>? tripData = snapshot.value as Map?;
    if (tripData == null) return;

    // Generate a unique trip ID using the uuid package. E.g: DT-0001
    String tripId = "DT-${Uuid().v4().substring(0, 4)}";

    // Save to Firestore
    await _firestore
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("DriveTrips")
        .doc(tripId)
        .set({
      "startTime": tripData["startTime"],
      "endTime": DateTime.now().toIso8601String(),
      "hardBrakes": tripData["hardBrakes"],
      "sharpTurns": tripData["sharpTurns"],
      "suddenAcceleration": tripData["suddenAcceleration"],
      "route": tripData["route"],
      "feedbackMessage": generateFeedback(tripData),
      "tripId": tripId,
    });

    // Delete active trip from Realtime Database
    await _db.remove();
  }

  String generateFeedback(Map<dynamic, dynamic> tripData) {
    int hardBrakes = tripData["hardBrakes"] ?? 0;
    int sharpTurns = tripData["sharpTurns"] ?? 0;
    int suddenAcceleration = tripData["suddenAcceleration"] ?? 0;

    if (hardBrakes > 3 || sharpTurns > 3 || suddenAcceleration > 3) {
      return "You had multiple hard brakes and sharp turns. Drive cautiously!";
    }
    return "Good job! Your driving was smooth and safe.";
  }

  //test function to check if the trip data is saved to firestore
  // Test function to simulate stopping a trip
  void simulateStopTrip() async {
    // Simulate trip data
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // The user is authenticated, proceed with the write request
    } else {
      return null;
    }

    Map<String, dynamic> simulatedTripData = {
      "startTime":
          DateTime.now().subtract(Duration(hours: 1)).toIso8601String(),
      "hardBrakes": 4,
      "sharpTurns": 0,
      "suddenAcceleration": 3,
      "route": [
        {"lat": 37.7749, "lng": -122.4194},
        {"lat": 34.0522, "lng": -118.2437},
      ],
    };

    // Set simulated data in the real-time database
    await _db.set(simulatedTripData);

    // Call stopTrip to save the data to Firestore and remove it from the real-time database
    stopTrip();
  }
}
