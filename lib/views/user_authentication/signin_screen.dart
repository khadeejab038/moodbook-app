import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebackend/views/user_authentication/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/database/user_database.dart';
import '../../models/user.dart' as AppUser;
import '../widgets/snack_bar_helper.dart';
import 'forgot_password_screen.dart';
import '../home/home_screen.dart';
import '../widgets/responsive_extension.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isloading=false;
  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isloading=true;
      });
      try {

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        showSnackBar(context, 'Sign-in successful!', Color(0xFF8B4CFC));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );

      } on FirebaseAuthException catch (e) {
        showSnackBar(context, e.message ?? 'Sign-in failed', Color(0xFF8B4CFC));
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      isloading = true;
    });
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() {
          isloading = false;
        });
        return; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Check if the user document exists in Firestore
        final AppUser.User? existingUser = await UserDatabase.fetchUserFromFirestore(user.uid);
        if (existingUser == null) {
          // If the user document does not exist, create and save a new one
          final AppUser.User newUser = AppUser.User(
            userID: user.uid,
            name: user.displayName ?? 'Google User',
            email: user.email ?? '',
            createdAt: DateTime.now(),
          );
          await UserDatabase.saveUserToFirestore(newUser);
        }
      }

      showSnackBar(context, 'Sign-in successful!', Color(0xFF8B4CFC));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      showSnackBar(context, 'Google Sign-In failed: $e', Color(0xFF8B4CFC));
    } finally {
      if (mounted) {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading?Center(child: CircularProgressIndicator()):Container(
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
                SizedBox(height: context.h(2.5)),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Padding(
                    padding: EdgeInsets.only(top: context.h(3)),
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

                SizedBox(height: context.h(3.5)),

                Container(
                  width: context.w(90).clamp(300.0, 360.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(context.w(5)),
                  ),
                child: Padding(
                  padding: EdgeInsets.all(context.w(8)),

                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter your Email',
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
                        SizedBox(height: context.h(3.5)),

                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Enter your Password',
                            hintStyle: const TextStyle(
                              fontFamily: 'Pangram',
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(Icons.key_outlined, size: context.w(5)),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: context.h(1.2)),

                        Align(
                          alignment: Alignment.centerRight,
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

                        SizedBox(height: context.h(2.5)),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xB2C9FAFB),
                            foregroundColor: Colors.black,
                            minimumSize: Size(double.infinity, context.h(6)), // Wider button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(context.w(3.5)), // No rounded edges
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


                        SizedBox(height: context.h(2.5)),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xB2C9FAFB),
                            foregroundColor: Colors.black, // Text color
                            minimumSize: Size(double.infinity, context.h(6)), // Wider button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(context.w(3.5)), // Slightly rounded edges
                            ),

                            elevation: 5, // Adds shadow
                            shadowColor: Color(0xFFCCEFFF),
                          ),
                          onPressed: _signInWithGoogle,
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


                        SizedBox(height: context.h(3.5)),


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
    ),
    );
  }
}
