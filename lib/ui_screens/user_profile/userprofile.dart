import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool isEditing = false;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
    //Initialise the text controllers with the user data
    if (currentUser?.displayName != null) {
      _nameController.text = currentUser!.displayName!;
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
                      backgroundImage: currentUser?.photoURL != null
                          ? NetworkImage(currentUser!.photoURL!)
                          : const AssetImage('assets/images/profile_pic.png') as ImageProvider,
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
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
                    icon: Icon(isEditing ? Icons.save : Icons.edit, color: Colors.white),
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
                      Icons.location_on, 'Address', _addressController),
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

  //_pickimage function
Future<void> _pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile == null) return;

  File imageFile = File(pickedFile.path);
  String fileName = 'profile_pics/${currentUser!.uid}.jpg';

  try {
    // Upload image to Firebase Storage
    TaskSnapshot snapshot = await FirebaseStorage.instance.ref(fileName).putFile(imageFile);
    
    // Get download URL
    String downloadUrl = await snapshot.ref.getDownloadURL();
    
    // Update Firebase Authentication profile photo URL
    await currentUser!.updatePhotoURL(downloadUrl);
    await currentUser!.reload(); // Reload user info

    // Get Firestore document ID
    QuerySnapshot userDoc = await _firestore.collection('Users').where('uid', isEqualTo: currentUser!.uid).get();
    
    if (userDoc.docs.isNotEmpty) {
      String docId = userDoc.docs.first.id; // Retrieve Firestore document ID

      // Update Firestore user profile
      await _firestore.collection('Users').doc(docId).update({
        'profilePicture': downloadUrl,
      });

      setState(() {
        currentUser = FirebaseAuth.instance.currentUser;
      });

      _showSnackbar('Profile picture updated successfully');
    } else {
      _showErrorSnackbar('User data not found in Firestore');
    }
  } catch (e) {
    log('Error uploading image: $e');
    _showErrorSnackbar('Failed to update profile picture');
  }
}

  Future<void> _updateUserData() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch the correct document based on user's UID
      QuerySnapshot userDoc = await _firestore
          .collection('Users')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (userDoc.docs.isNotEmpty) {
        String docId = userDoc.docs.first.id; // Correct way to get Firestore doc ID

        // Update user data in Firestore
        await _firestore.collection('Users').doc(docId).update({
          'username': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
        });

        // Update FirebaseAuth displayName
        await user.updateDisplayName(_nameController.text);
        await user.reload(); // Reload user info

        // Show success message
        _showSnackbar('User data updated successfully');

        // Refresh UI
        setState(() {
          currentUser = FirebaseAuth.instance.currentUser;
        });
      } else {
        _showErrorSnackbar('User data not found in Firestore');
  }
}
} catch (e) {
    log('Error updating user data: $e');
      _showErrorSnackbar('Error updating user data');
    }
  }
}