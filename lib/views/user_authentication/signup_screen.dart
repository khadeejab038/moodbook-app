import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/database/user_database.dart';
import '../widgets/snack_bar_helper.dart';
import '../home/home_screen.dart';
import '../widgets/responsive_extension.dart';

// Import your custom User model with an alias
import '../../models/user.dart' as AppUser;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController(); // Added name controller
  final _formKey = GlobalKey<FormState>();

  // Register user and save data to Firestore
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create user with email and password
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // After registration, save the user's name, email, and creation time to Firestore
        User? user = userCredential.user;
        if (user != null) {
          // Create or update the user document in Firestore
          AppUser.User newUser = AppUser.User( // Use AppUser.User here
            userID: user.uid,
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            createdAt: DateTime.now(), // Use DateTime.now() for createdAt
          );

          // Use UserDatabase to save the user to Firestore
          await UserDatabase.saveUserToFirestore(newUser);

          // Show success message
          showSnackBar(context, 'Sign-up successful!', Color(0xFF8B4CFC));

          // Navigate to home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Handle errors during registration
        showSnackBar(context, e.message ?? 'Sign-up failed', Color(0xFF8B4CFC));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.5, -0.5),
            radius: 1.8,
            colors: [
              Color(0xFFF3EAF8),
              Color(0xFFFF92A9),
              Color(0xFFCCEFFF),
            ],
            stops: [0, 0.4, 0.9],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Padding(
                    padding: EdgeInsets.only(top: context.h(3)),
                    child: Center(
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'Pangram',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.h(3.5)),
                Container(
                  width: context.w(90).clamp(300.0, 360.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(context.w(5)),
                  ),
                child: Padding(
                  padding: EdgeInsets.all(context.w(6.5)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Name input field
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            hintStyle: const TextStyle(
                              fontFamily: 'Pangram',
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(Icons.person_outline, size: context.w(5)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: context.h(3)),
                        // Email input field
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: const TextStyle(
                              fontFamily: 'Pangram',
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(Icons.email_outlined, size: context.w(5)),
                          ),
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: context.h(3)),
                        // Password input field
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            hintStyle: const TextStyle(
                              fontFamily: 'Pangram',
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(Icons.key, size: context.w(5)),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: context.h(3)),
                        // Sign-up button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xB2C9FAFB),
                            foregroundColor: Colors.black,
                            minimumSize: Size(double.infinity, context.h(6)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(context.w(3.5)),
                            ),
                            elevation: 5,
                            shadowColor: Color(0xFFCCEFFF),
                          ),
                          onPressed: _signUp,
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontFamily: 'Pangram',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: context.h(2)),
                        // Google sign-in button (placeholder)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xB2C9FAFB),
                            foregroundColor: Colors.black,
                            minimumSize: Size(double.infinity, context.h(6)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(context.w(3.5)),
                            ),
                            elevation: 5,
                            shadowColor: Color(0xFFCCEFFF),
                          ),
                          onPressed: () {
                            // Add your Google sign-in logic here
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(context.w(2)),
                                child: Image.asset('assets/google.png', height: context.h(2.5)),
                              ),
                              const Text(
                                'Sign In with Google',
                                style: TextStyle(
                                  fontFamily: 'Pangram',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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
      ),
    ),
    );
  }
}
