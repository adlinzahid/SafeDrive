import 'dart:developer';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_drive/services/profile_image_service.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();
  
  bool isEditing = false;
  User? currentUser;
  String? currentUserPhoto; // Store base64 profile image

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;

    if (currentUser == null) {
      // If the user is not authenticated, show a message or navigate to login
      Navigator.of(context)
          .pushReplacementNamed('/login'); // Navigate to login page
      return;
    }

    // Load user data from Firestore
  fetchUserProfile();
  }

  Future<void> _updateUserData() async {
    if (currentUser == null) {
      log("No authenticated user found.");
      return;
    }

    try {
      log("Updating user profile for UID: ${currentUser!.uid}");

//update user data in firestore
      await _firestore.collection('Users').doc(currentUser!.uid).update({
        'username': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'vehicleNumber': _vehicleController.text.trim(),
      });

      log("User profile updated successfully!");

// Fetch updated data from Firestore and update UI
    await fetchUserProfile();

      setState(() {
        isEditing = false;
      });

      _showSnackbar("Profile updated successfully!");
    } catch (e) {
      log('Error updating profile: $e'); // Logs the exact error
      _showErrorSnackbar("Failed to update profile. $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'User Profile',
          style: TextStyle(
            color: Colors.yellowAccent[700],
            fontFamily: 'Montserrat',
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context)
                .pop(); // Navigates back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: currentUserPhoto != null
                          ? MemoryImage(base64Decode(
                              currentUserPhoto!)) // Show base64 image
                          : const AssetImage('assets/images/profile_pic.png')
                              as ImageProvider,
                      child: currentUserPhoto == null
                          ? const Icon(Icons.camera_alt,
                              color: Colors.white, size: 30)
                          : null, // Hide icon if image exists
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    enabled: isEditing,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                  IconButton(
                    icon: Icon(isEditing ? Icons.save : Icons.edit,
                        color: Colors.white),
                    onPressed: () async {
                      if (isEditing) {
                        await _updateUserData();
                      }
                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildEditableField(
                    Icons.person,
                    currentUser?.displayName ?? 'Name',
                    _nameController,
                  ),
                  _buildEditableField(Icons.email,
                      currentUser?.email ?? 'Email', _emailController),
                  _buildEditableField(Icons.phone, 'Phone', _phoneController),
                  _buildEditableField(
                      Icons.drive_eta, 'Vehicle Number', _vehicleController),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(
      IconData icon, String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.purple,
        ),
        controller: controller,
        obscureText: obscureText,
        enabled: isEditing,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.purple),
          labelText: isEditing ? null : label, // Hide label when editing
          hintText: label, // Show hint text
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.yellowAccent[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        showCloseIcon: true,
      ),
    );
  }

  _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        showCloseIcon: true,
      ),
    );
  }

//loadUserProfile
  Future<void> _loadUserProfile() async {
    DocumentSnapshot doc =
        await _firestore.collection('Users').doc(currentUser!.uid).get();

    if (doc.exists) {
      setState(() {
        currentUserPhoto = doc['profilePicture']; // Fetch stored base64 image
      });
    }
  }

  //_pickimage function
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image =
        base64Encode(imageFile.readAsBytesSync()); // Convert to base64

    try {
      await _firestore.collection('Users').doc(currentUser!.uid).update({
        'profilePicture': base64Image,
      });

      setState(() {
        currentUserPhoto = base64Image; // Store image in state for UI update
      });

      _showSnackbar('Profile picture updated');
    } catch (e) {
      log('Error uploading image: $e');
      _showErrorSnackbar('Failed to update profile picture');
    }
  }

  Future<void> updateUserProfile(
      String userId, String name, String phone, String vehicleNumber) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'username': name,
        'phone': phone,
        'vehicleNumber': vehicleNumber,
      });
      print("User profile updated successfully!");
    } catch (e) {
      print("Error updating profile: $e");
    }

}

//fetchUserprofile
Future<void> fetchUserProfile() async {
  if (currentUser == null) return;

  try {
    DocumentSnapshot userDoc =
        await _firestore.collection('Users').doc(currentUser!.uid).get();

    if (userDoc.exists) {
      setState(() {
        _nameController.text = userDoc['username'] ?? '';
        _emailController.text = userDoc['email'] ?? '';
        _phoneController.text = userDoc['phone'] ?? '';  // Ensure this is fetched
        _vehicleController.text = userDoc['vehicleNumber'] ?? ''; // Fix here
      });
    }
  } catch (e) {
    log("Error fetching user profile: $e");
  }
}


  }
