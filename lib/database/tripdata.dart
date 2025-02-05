//user will stop the trip by clicking on the stop button and the trip data will be saved to firestore and deleted from real time database
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class TripData {
  Future<void> stopTrip() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      log('User is not authenticated');
      return;
    }

    DatabaseReference tripRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://safedrive-f52ba-default-rtdb.asia-southeast1.firebasedatabase.app/",
    ).ref().child("Users").child(user.uid).child("ActiveTrip");

    try {
      log('Stopping trip...');
      DatabaseEvent event = await tripRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<String, dynamic>? tripData =
            Map<String, dynamic>.from(snapshot.value as Map);

        tripData["endTime"] = DateTime.now().toIso8601String();
        tripData["feedbackMessage"] = generateFeedbackMessage(tripData);

        //Generate a unique ID for the trip data. Eg. DT-0000
        var uuid = const Uuid();
        String tripId = 'DT-${uuid.v4().substring(0, 4).toUpperCase()}';

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .collection("DriveTrips")
            .doc(tripId)
            .set(tripData);

        await tripRef.remove(); // Clear active trip data
        log("Trip data moved to Firestore and deleted from Realtime Database.");
      } else {
        log("No active trip data found.");
      }
    } catch (e) {
      log("Error stopping trip: $e");
    }
  }

  String generateFeedbackMessage(Map<String, dynamic> tripData) {
    int hardBrakes = tripData["hardBrakes"] ?? 0;
    int sharpTurns = tripData["sharpTurns"] ?? 0;
    int suddenAcceleration = tripData["suddenAcceleration"] ?? 0;

    List<String> feedback = [];

    if (hardBrakes > 0) {
      feedback.add("Hard brakes: $hardBrakes times. Maintain safe distance.");
    }
    if (sharpTurns > 0) {
      feedback.add("Sharp turns: $sharpTurns times. Slow down on curves.");
    }
    if (suddenAcceleration > 0) {
      feedback.add(
          "Sudden acceleration: $suddenAcceleration times. Drive smoothly.");
    }

    return feedback.isEmpty
        ? "Great driving!"
        : "During your past drive:\n- ${feedback.join("\n- ")}";
  }
//simulate data to check the functionality

  void simulateTripData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      log('User is not authenticated');
      return;
    }

    DatabaseReference tripRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://safedrive-f52ba-default-rtdb.asia-southeast1.firebasedatabase.app/",
    ).ref().child("Users").child(user.uid).child("ActiveTrip");

    try {
      log('Simulating trip data...');
      await tripRef.set({
        "startTime": DateTime.now().toIso8601String(),
        "hardBrakes": 2,
        "sharpTurns": 2,
        "suddenAcceleration": 1,
        "speed": 0.0,
        "route": [],
        "paused": false,
        "endTime": null,
      });
      log('Trip data simulated successfully.');

      //now save the trip data to firestore, use if else statement to check if the trip data is saved to firestore
      DatabaseEvent event = await tripRef.once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot != null) {
        Map<String, dynamic>? tripData =
            Map<String, dynamic>.from(snapshot.value as Map);

        tripData["endTime"] = DateTime.now().toIso8601String();
        tripData["feedbackMessage"] = generateFeedbackMessage(tripData);

        //Generate a unique ID for the trip data. Eg. DT-0000
        var uuid = const Uuid();
        String tripId = 'DT-${uuid.v4().substring(0, 4).toUpperCase()}';

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .collection("DriveTrips")
            .doc(tripId)
            .set(tripData);

        await tripRef.remove(); // Clear active trip data
        log("Trip data moved to Firestore and deleted from Realtime Database.");
      } else {
        log("No active trip data found.");
      }
    } catch (e) {
      log('Error simulating trip data: $e');
    }
  }

//method to fetch the trip data from firestore
  Future<DocumentSnapshot> fetchTripData(tripId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      log('User is not authenticated');
      return Future.error('User is not authenticated');
    }

    //get the collection of the user's trip data for the current user
    final tripData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('DriveTrips')
        .doc(tripId)
        .get();

    return tripData;
  }
}
