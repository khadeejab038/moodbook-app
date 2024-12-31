import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Utils/snack_bar_helper.dart';
import '../home/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        showSnackBar(context, 'Sign-up successful!', Colors.green);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        showSnackBar(context, e.message ?? 'Sign-up failed', Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white), // White back button
                  onPressed: () {
                    Navigator.pop(context); // Go back to previous screen
                  },
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 25.0, left: 100),
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
              const SizedBox(height: 100),
              Container(
                height: 450,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your Email',
                            hintStyle: TextStyle(
                              fontFamily: 'Pangram',
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(Icons.email_outlined, size: 20),
                          ),
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your Password',
                            hintStyle: TextStyle(
                              fontFamily: 'Pangram',
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(Icons.key, size: 20),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
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
                          onPressed: _signUp,
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontFamily: 'Pangram',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                          onPressed: () {
                            // Add your Google sign-in logic here
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset('lib/assets/google.png', height: 20),
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
    );
  }
}
