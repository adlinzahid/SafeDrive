import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController nameController = TextEditingController(text: 'Yarewan Williamson');
  final TextEditingController phoneController = TextEditingController(text: '+12 123 123 123');
  final TextEditingController emailController = TextEditingController(text: 'yarewill125@gmail.com');
  final TextEditingController genderController = TextEditingController(text: 'Male');
  final TextEditingController birthdateController = TextEditingController(text: '01/01/1990');
  final TextEditingController addressController = TextEditingController(text: '123 Main St, Springfield');
  final TextEditingController passwordController = TextEditingController();

  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('User Profile', style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Navigates back to the previous screen
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
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile_pic.png'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    textAlign: TextAlign.center,
                    enabled: isEditing,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                  IconButton(
                    icon: Icon(isEditing ? Icons.save : Icons.edit, color: Colors.white),
                    onPressed: () {
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
                  _buildEditableField(Icons.account_circle, 'Gender', genderController),
                  _buildEditableField(Icons.cake, 'Birthday', birthdateController),
                  _buildEditableField(Icons.phone, 'Phone', phoneController),
                  _buildEditableField(Icons.email, 'Email', emailController),
                  _buildEditableField(Icons.location_on, 'Address', addressController),
                  _buildEditableField(Icons.lock, 'Enter Password', passwordController, obscureText: true),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(IconData icon, String label, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        enabled: isEditing,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.purple),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
