//this is the file to  start track user's driving trip using real time database and then save to firestoreimport 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DrivingTracker {
  DatabaseReference? _realtime;

//Initialize the trip data and start tracking the user's location and speed

  Future<void> initializeTracker() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      log("Initializing tracker for user ID: ${user.uid}");
      _realtime = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            "https://safedrive-f52ba-default-rtdb.asia-southeast1.firebasedatabase.app/",
      ).ref().child("Users").child(user.uid).child("ActiveTrip");
    } else {
      log("Failed to initialize tracker: User ID $user not found");
    }
  }

  Future<void> startTrip() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      log("User not authenticated");
      return;
    }

    await initializeTracker();
    if (_realtime == null) {
      log("Database reference not initialized.");
      return;
    }

    try {
      log('Starting trip...');
      await _realtime!.set({
        "startTime": DateTime.now().toIso8601String(),
        "hardBrakes": 0,
        "sharpTurns": 0,
        "suddenAcceleration": 0,
        "speed": 0.0,
        "route": [],
        "paused": false,
        "endTime": null,
      });

      log('Tracking location & speed...');
      Geolocator.getPositionStream(
        locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high, distanceFilter: 10),
      ).listen((Position position) {
        double speed = position.speed;
        _realtime!.child("speed").set(speed);

        if (speed > 22.22) {
          showSpeedAlert();
        }
      });
    } catch (e) {
      log('Error starting trip: $e');
    }
  }

  void pauseTrip() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      log("User not authenticated");
      return;
    }

    log('Pausing trip...');
    _realtime?.child("paused").set(true);
  }

  void resumeTrip() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      log("User not authenticated");
      return;
    }

    log('Resuming trip...');
    _realtime?.child("paused").set(false);
  }

  void showSpeedAlert() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      log("User not authenticated");
      return;
    }
    Fluttertoast.showToast(
        msg: "You are driving above the speed limit!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
