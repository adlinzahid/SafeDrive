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
      log("Error: No authenticated user found.");
      return;
    }

    String userId = user.uid;
    log("Stopping trip for user ID: $userId");

    DatabaseReference tripRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://safedrive-f52ba-default-rtdb.asia-southeast1.firebasedatabase.app/",
    ).ref().child("Users").child(userId).child("ActiveTrip");

    try {
      log('Fetching active trip data...');
      DatabaseEvent event = await tripRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (!snapshot.exists) {
        log("No active trip data found.");
        return;
      }

      Map<String, dynamic> tripData =
          Map<String, dynamic>.from(snapshot.value as Map);

      tripData["endTime"] = DateTime.now().toIso8601String();
      tripData["feedbackMessage"] = generateFeedbackMessage(tripData);

      // Generate a unique trip ID
      String tripId = 'DT-${Uuid().v4().substring(0, 4).toUpperCase()}';

      //Query Firestore to find the correct user document and save the trip data
      QuerySnapshot userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .where("uid", isEqualTo: user.uid)
          .get();

      if (userDoc.docs.isNotEmpty) {
        DocumentReference userRef = userDoc.docs.first.reference;

        // Save trip data inside the correct user document
        await userRef.collection("DriveTrips").doc(tripId).set(tripData);
        tripData["tripId"] = tripRef.key;

        log("Trip data saved successfully in Firestore for ${user.uid} with email ${user.email}.");
      } else {
        log("Error: No user document found for Firebase UID: ${user.uid}");
        return;
      }

      await tripRef.remove(); // Remove from Realtime Database
      log("Trip data removed from Realtime Database.");
    } catch (e) {
      log("Error while stopping trip: $e");
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
}
