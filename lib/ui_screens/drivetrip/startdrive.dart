//This file is to track the user's start drive details using real-time database
import 'dart:async';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/widgets.dart';

class UserStartDrive with WidgetsBindingObserver {
  final String userId;
  late DatabaseReference tripRef;
  StreamSubscription<UserAccelerometerEvent>? _userAccelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  UserStartDrive({required this.userId}) {
    tripRef = FirebaseDatabase.instance.ref("Users/$userId/ActiveTrip");
    WidgetsBinding.instance.addObserver(this);
  }

  void startTracking() {
    tripRef.set({
      "startTime": DateTime.now().toIso8601String(),
      "hardBrakes": 0,
      "sharpTurns": 0,
      "speedData": [],
    });

    // //manually simulate the accelerometer and gyroscope events ever seconds
    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   _processAcceleration(
    //       UserAccelerometerEvent(0.0, 0.0, -12.0, 0.0 as DateTime));
    //   _processRotation(GyroscopeEvent(3.0, 0.0, 0.0, 0.0 as DateTime));
    //   _simulateSpeedData();
    // });

    _userAccelerometerSubscription = userAccelerometerEventStream().listen(
      (event) => _processAcceleration(event),
      onError: (error) => log("Accelerometer error: $error"),
    );

    _gyroscopeSubscription = gyroscopeEventStream().listen(
      (event) => _processRotation(event),
      onError: (error) => log("Gyroscope error: $error"),
    );
  }

  //simulate speed data to test the app in the absence of a real-time speed sensor
  // void _simulateSpeedData() {
  //   // Simulate random speed values
  //   List<int> fakeSpeeds = [20, 40, 60, 80, 100, 120, 140];
  //   int randomSpeed = (fakeSpeeds..shuffle()).first;

  //   tripRef.child("speedData").get().then((snapshot) {
  //     List<dynamic> currentSpeeds =
  //         snapshot.exists ? List<dynamic>.from(snapshot.value as List) : [];
  //     currentSpeeds.add(randomSpeed);
  //     tripRef.update({"speedData": currentSpeeds});
  //   });

  //   log("🚗 Simulated Speed: $randomSpeed km/h");
  // }

  void _processAcceleration(UserAccelerometerEvent event) {
    log("Acceleration: x=${event.x}, y=${event.y}, z=${event.z}");

    double threshold = 10.0;
    if (event.z < -threshold) {
      tripRef.child("hardBrakes").runTransaction((currentData) {
        int currentBrakes = (currentData as int?) ?? 0;
        return Transaction.success(currentBrakes + 1);
      });
    }
  }

  void _processRotation(GyroscopeEvent event) {
    log("Gyroscope: x=${event.x}, y=${event.y}, z=${event.z}");

    double turnThreshold = 2.5;
    if (event.y.abs() > turnThreshold || event.x.abs() > turnThreshold) {
      tripRef.child("sharpTurns").runTransaction((currentData) {
        int currentTurns = (currentData as int?) ?? 0;
        return Transaction.success(currentTurns + 1);
      });
    }
  }

  void stopTracking() {
    _userAccelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    tripRef.update({"endTime": DateTime.now().toIso8601String()});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      stopTracking();
    } else if (state == AppLifecycleState.resumed) {
      startTracking();
    }
  }
}
