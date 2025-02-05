import 'dart:developer';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();

  bool isEditing = false;
  final user = FirebaseAuth.instance.currentUser;
  String? currentUserPhoto; // Store base64 profile image

  @override
  void initState() {
    super.initState();

    if (user == null) {
      // If the user is not authenticated, show a message or navigate to login
      Navigator.of(context)
          .pushReplacementNamed('/login'); // Navigate to login page
      return;
    }

    // Load user data from Firestore
    fetchUserProfile();
  }

  Future<void> _updateUserData() async {
    if (user == null) {
      log("No authenticated user found.");
      return;
    }

    try {
      // Query to find the document with the specified UID
      QuerySnapshot userQuery = await _firestore
          .collection('Users')
          .where('uid', isEqualTo: user!.uid)
          .get();

      if (userQuery.docs.isEmpty) {
        log("User document for ${user!.uid} is not found");
        return;
      }

      // Assuming only one document with that UID exists, fetch the reference of the first document
      DocumentReference userRef = userQuery.docs[0].reference;

      log("User document found: ${userQuery.docs[0].data()}");

      // Update the user document with the new data
      await userRef.update({
        'username': _nameController.text,
        'phone': _phoneController.text,
        'vehicleNumber': _vehicleController.text,
      });

      // Fetch updated profile data
      await fetchUserProfile();

      setState(() {
        isEditing = false;
      });

      _showSnackbar("Profile updated successfully!");
    } catch (e) {
      log('Error updating profile: $e');
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
                      backgroundImage: currentUserPhoto != null &&
                              currentUserPhoto!.isNotEmpty
                          ? MemoryImage(base64Decode(
                              currentUserPhoto!)) // Correct base64 image
                          : const AssetImage('assets/images/profile_pic.png')
                              as ImageProvider,
                      child: currentUserPhoto == null
                          ? const Icon(Icons.camera_alt,
                              color: Colors.white, size: 30)
                          : null,
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
                    user?.displayName ?? 'Name',
                    _nameController,
                  ),
                  _buildEditableField(
                      Icons.email, user?.email ?? 'Email', _emailController),
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
        backgroundColor: Colors.green[500],
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

  //_pickimage function
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image =
        base64Encode(imageBytes); // Convert to base64 correctly

    try {
      // Fetch correct user document using email
      QuerySnapshot userQuery = await _firestore
          .collection('Users')
          .where('email', isEqualTo: user!.email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        String userId = userQuery.docs.first.id; // Get correct document ID

        // Update Firestore with base64 image
        await _firestore.collection('Users').doc(userId).update({
          'profilePicture': base64Image,
        });

        setState(() {
          currentUserPhoto = base64Image;
        });

        _showSnackbar('Profile picture updated');
      }
    } catch (e) {
      log('Error uploading image: $e');
      _showErrorSnackbar('Failed to update profile picture');
    }
  }

//update user profile
  // Future<void> updateUserProfile(
  //     String name, String phone, String vehicleNumber) async {
  //   try {
  //     QuerySnapshot userQuery = await _firestore
  //         .collection('Users')
  //         .where('email', isEqualTo: user!.email)
  //         .get();

  //     if (userQuery.docs.isNotEmpty) {
  //       String userId = userQuery.docs.first.id; // Fetch correct ID

  //       await _firestore.collection('Users').doc(userId).update({
  //         'username': name,
  //         'phone': phone,
  //         'vehicleNumber': vehicleNumber,
  //       });

  //       _showSnackbar("User profile updated successfully!");
  //     }
  //   } catch (e) {
  //     log("Error updating profile: $e");
  //     _showErrorSnackbar("Failed to update profile.");
  //   }
  // }

//fetchUserprofile
  Future<void> fetchUserProfile() async {
    try {
      QuerySnapshot userQuery = await _firestore
          .collection('Users')
          .where('uid', isEqualTo: user!.uid)
          .get();

      if (userQuery.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userQuery.docs.first;

        setState(() {
          _nameController.text = userDoc['username'];
          _phoneController.text = userDoc['phone'];
          _emailController.text = userDoc['email'];
          _vehicleController.text = userDoc['vehicleNumber'];
          currentUserPhoto = userDoc['profilePicture'];
        });
      }
    } catch (e) {
      log('Error fetching user profile: $e');
    }
  }
}
