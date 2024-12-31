import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import '../../../Services/database_services_users.dart';
import '../../../Models/user.dart' as model;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String currentEmail = ""; // To store the user's current email
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      model.User? currentUser = await DatabaseServicesUsers.fetchCurrentUser(); // Using model.User
      if (currentUser != null) {
        setState(() {
          name = currentUser.name;
          email = currentUser.email;
          currentEmail = currentUser.email;
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to prompt user for their password (necessary for re-authentication)
  Future<String?> _promptForPassword() async {
    String? password = '';
    await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Password'),
          content: TextField(
            obscureText: true,
            onChanged: (value) {
              password = value;
            },
            decoration: InputDecoration(hintText: 'Password'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop(password);
              },
            ),
          ],
        );
      },
    );
    return password;
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;

        if (firebaseUser != null && email != currentEmail) {
          // Prompt user for password to re-authenticate
          String? userPassword = await _promptForPassword();

          if (userPassword != null && userPassword.isNotEmpty) {
            // Re-authenticate user
            final auth.AuthCredential credential = auth.EmailAuthProvider.credential(
              email: currentEmail,
              password: userPassword,
            );
            await firebaseUser.reauthenticateWithCredential(credential);

            // Update email in Firebase Authentication
            await firebaseUser.updateEmail(email);
          } else {
            throw Exception("Password not provided.");
          }
        }

        // Update user data in Firestore
        model.User? currentUser = await DatabaseServicesUsers.fetchCurrentUser();
        if (currentUser != null) {
          currentUser.name = name;
          currentUser.email = email;
          await DatabaseServicesUsers.updateUserInFirestore(currentUser.userID, currentUser);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          Navigator.pop(context);
        }
      } on auth.FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in again to update your email.')),
          );
          // Optionally, you can redirect the user to the login screen.
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update email: ${e.message}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
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
                  child: Form(
                    key: _formKey,
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
                                fontFamily: 'Pangram',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 70),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Change profile picture clicked!")),
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
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Pangram',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: name,
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Name cannot be empty";
                            }
                            return null;
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
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Pangram',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: email,
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(r"^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$").hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter your email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xB2C9FAFB),
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            shadowColor: Color(0xFFCCEFFF),
                          ),
                          onPressed: _updateUserProfile,
                          child: const Text('Update Profile'),
                        ),
                      ],
                    ),
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
