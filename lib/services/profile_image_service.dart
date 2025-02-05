import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileImageService {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Save base64 string to Firestore
      await FirebaseFirestore.instance.collection('Users').doc(user?.uid).update({
        'profilePicture': base64Image,
      });

      log("Profile picture updated!");
    }
  }
}
