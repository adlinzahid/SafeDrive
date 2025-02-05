//this file will fetch the latest trip details from the database and display it in the app

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Latesttrip {
  Future<DocumentSnapshot> fetchLatestTrip() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Future.error("Error: No authenticated user found.");
    }

    String userId = user.uid;
    log("Fetching latest trip for user ID: $userId");

    //query firestore to find the right user document first
    QuerySnapshot userDoc = await FirebaseFirestore.instance
        .collection("Users")
        .where("uid", isEqualTo: user.uid)
        .limit(1)
        .get();

    //fetch the latest trip data from the user document
    DocumentSnapshot tripDoc = await userDoc.docs.first.reference
        .collection("DriveTrips")
        .orderBy("startTime", descending: true)
        .limit(1)
        .get()
        .then((value) => value.docs.first);
    log('Latest trip fetched: ${tripDoc.data()}');
    return tripDoc;
  }
}
