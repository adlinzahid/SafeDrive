import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileImageService {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadImage(String userId) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Save base64 string to Firestore
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'profilePicture': base64Image,
      });

      print("Profile picture updated!");
    }
  }
}
