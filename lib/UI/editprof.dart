import 'package:flutter/material.dart';

class EditProf extends StatefulWidget {
  const EditProf({super.key});

  @override
  State<EditProf> createState() => _EditProfState();
}

class _EditProfState extends State<EditProf> {
  String name = "";
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.4,
                    colors: [
                      Color(0xFFCCEFFF),
                      Color(0xFFEFF9F2),
                      Color(0xFFCFCFCF),
                    ],
                    stops: [0.3, 0.8, 1],
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          BackButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 80),
                          const Text(
                            "Edit Profile",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Pangram'
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 70),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Add functionality to pick profile picture
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Change profile picture clicked!"),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.grey[300],
                            child: const Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Edit Name Field

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Name",
                          style: TextStyle(fontSize: 16, fontFamily: 'Pangram', fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Edit Email Field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Email Address",
                          style: TextStyle(fontSize: 16, fontFamily: 'Pangram', fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your email address",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 150),

                      // Save Changes Button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B4CFC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50.0,
                              vertical: 20.0,
                            ),
                          ),
                          onPressed: () {
                            // Handle save action
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Profile updated!\nName: $name\nEmail: $email"),
                              ),
                            );
                          },
                          child: const Text(
                            "Save Changes",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
