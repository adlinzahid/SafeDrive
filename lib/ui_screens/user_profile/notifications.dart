// import 'package:flutter/material.dart';
// import 'package:safe_drive/components/safedrivebutton.dart';

// class Notifications extends StatelessWidget {
//   const Notifications({super.key});

//   // Function to show a driving behavior notification
//   static void showDrivingAlert(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Safe Drive Notifications"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [

//             Safedrivebutton(
//               text: "Simulate Driving Behavior",
//               onTap: () {
//                 // Simulate different driving behavior based on the speed
//                 _simulateDrivingSpeed(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Simulate different driving behavior and show alerts
//   void _simulateDrivingSpeed(BuildContext context) {
//     // Simulate a random speed (for example, a random number between 40 and 120 km/h)
//     double simulatedSpeed = 40 + (100 * (0.5 - 0.1));  // Simulated random speed

//     if (simulatedSpeed > 100) {
//       Notifications.showDrivingAlert(context, 'You are driving too fast! Please slow down.');
//     } else if (simulatedSpeed < 50) {
//       Notifications.showDrivingAlert(context, 'You are driving too slow. Keep going!');
//     } else {
//       Notifications.showDrivingAlert(context, 'Excellent driving! Keep it up!');
//     }
//   }
// }
