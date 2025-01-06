import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebackend/UI/userAuthentication/signup_screen.dart';
import 'package:flutter/material.dart';
import '../../Utils/snack_bar_helper.dart';
import 'forgot_password_screen.dart';
import '../home/home_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        showSnackBar(context, 'Sign-in successful!', Colors.green);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        showSnackBar(context, e.message ?? 'Sign-in failed', Colors.red);
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
              SizedBox(height: 40),
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: const Text(
                      'Welcome to MoodBook!',
                      style: TextStyle(
                        fontFamily: 'Pangram',
                        fontWeight: FontWeight.w600,
                        fontSize: 26,
                        color: Color(0xFFFFFFFF),
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 4.0,
                            color: Color(0x80000000),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 60),

              Container(
                height: 500,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),

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
                            prefixIcon: Icon(Icons.email_outlined, size: 20,),
                          ),
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your Password',
                            hintStyle: TextStyle(
                              fontFamily: 'Pangram',
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(Icons.key_outlined, size: 20,),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.only(left: 160.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen()),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontFamily: 'Pangram',
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xB2C9FAFB),
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50), // Wider button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0), // No rounded edges
                            ),

                            elevation: 5, // Adds shadow
                            shadowColor: Color(0xFFCCEFFF),
                          ),
                          onPressed: _signIn,
                          child: const Text(
                            'Sign In',
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
                            foregroundColor: Colors.black, // Text color
                            minimumSize: const Size(double.infinity, 50), // Wider button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0), // Slightly rounded edges
                            ),

                            elevation: 5, // Adds shadow
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
                                child: Image.asset('assets/google.png', height: 20),
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


                        const SizedBox(height: 30),


                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpScreen()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Not a registered user?',
                                style: TextStyle(
                                  fontFamily: 'Pangram',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF8B4CFC),
                                  decoration: TextDecoration.underline,
                                ),
                              ),

                              const Text(
                                ' Sign Up',
                                style: TextStyle(
                                  fontFamily: 'Pangram',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
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
