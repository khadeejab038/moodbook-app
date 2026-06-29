import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebackend/views/user_authentication/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/database/user_database.dart';
import '../../models/user.dart' as AppUser;
import '../../theme/app_colors.dart';
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

  bool isloading = false;
  bool _obscurePassword = true;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        showSnackBar(context, 'Sign-in successful!', AppColors.primary);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );

      } on FirebaseAuthException catch (e) {
        showSnackBar(context, e.message ?? 'Sign-in failed', AppColors.primary);
        setState(() {
          isloading = false;
        });
      } catch (e) {
        showSnackBar(context, 'Sign-in failed: $e', AppColors.primary);
        setState(() {
          isloading = false;
        });
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

      showSnackBar(context, 'Sign-in successful!', AppColors.primary);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      showSnackBar(context, 'Google Sign-In failed: $e', AppColors.primary);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Background gradient
    final backgroundGradient = isDark
        ? const RadialGradient(
            center: Alignment(-0.5, -0.5),
            radius: 1.8,
            colors: [
              Color(0xFF1A1324),
              Color(0xFF2C1625),
              Color(0xFF101925),
            ],
            stops: [0, 0.5, 0.9],
          )
        : const RadialGradient(
            center: Alignment(-0.5, -0.5),
            radius: 1.8,
            colors: [
              Color(0xFFF3EAF8),
              Color(0xFFFF92A9),
              Color(0xFFCCEFFF),
            ],
            stops: [0, 0.4, 0.9],
          );

    // Card background
    final cardColor = isDark ? const Color(0xFF241C30) : AppColors.primaryLight;
    
    // Text colors
    final cardTextColor = isDark ? Colors.white : Colors.black;
    final cardSubtitleColor = isDark ? Colors.white70 : Colors.black54;
    final helperTextColor = isDark ? Colors.white30 : Colors.black38;
    
    // Text field styles
    final inputFillColor = isDark ? const Color(0xFF140E1B) : Colors.white;
    final inputBorderColor = isDark ? Colors.transparent : Colors.grey.shade300;

    // Button style
    final buttonColor = isDark ? AppColors.primary : const Color(0xB2C9FAFB);
    final buttonTextColor = isDark ? Colors.white : Colors.black;
    final buttonShadowColor = isDark ? Colors.transparent : const Color(0xFFCCEFFF);

    return Scaffold(
      body: isloading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: backgroundGradient,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: context.h(3), horizontal: context.w(5)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
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
                            SizedBox(height: context.h(4)),
                            Container(
                              width: context.w(90).clamp(300.0, 360.0),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(context.w(5)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 15,
                                    offset: Offset(0, 5),
                                  ),
                                ],
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
                                        style: TextStyle(
                                          fontFamily: 'Pangram',
                                          fontWeight: FontWeight.w500,
                                          color: cardTextColor,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: inputFillColor,
                                          hintText: 'Enter your Email',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Pangram',
                                            fontWeight: FontWeight.w500,
                                            color: cardSubtitleColor,
                                          ),
                                          helperText: 'Format: name@example.com',
                                          helperStyle: TextStyle(
                                            fontFamily: 'Pangram',
                                            fontSize: 11,
                                            color: helperTextColor,
                                          ),
                                          prefixIcon: Icon(Icons.email_outlined, size: context.w(5), color: cardSubtitleColor),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide(color: inputBorderColor, width: 1.5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide(color: inputBorderColor, width: 1.5),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          if (!value.contains('@')) {
                                            return 'Email must contain @ symbol';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: context.h(3)),
                                      TextFormField(
                                        controller: _passwordController,
                                        style: TextStyle(
                                          fontFamily: 'Pangram',
                                          fontWeight: FontWeight.w500,
                                          color: cardTextColor,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: inputFillColor,
                                          hintText: 'Enter your Password',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Pangram',
                                            fontWeight: FontWeight.w500,
                                            color: cardSubtitleColor,
                                          ),
                                          helperText: 'Must be at least 6 characters',
                                          helperStyle: TextStyle(
                                            fontFamily: 'Pangram',
                                            fontSize: 11,
                                            color: helperTextColor,
                                          ),
                                          prefixIcon: Icon(Icons.key_outlined, size: context.w(5), color: cardSubtitleColor),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                              size: context.w(5),
                                              color: cardSubtitleColor,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword = !_obscurePassword;
                                              });
                                            },
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide(color: inputBorderColor, width: 1.5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: BorderSide(color: inputBorderColor, width: 1.5),
                                          ),
                                        ),
                                        obscureText: _obscurePassword,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          if (value.length < 6) {
                                            return 'Password is too short (min 6 characters)';
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
                                              MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                                            );
                                          },
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              fontFamily: 'Pangram',
                                              fontWeight: FontWeight.w500,
                                              color: cardTextColor == Colors.white ? Colors.white70 : Colors.black87,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: context.h(2.5)),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: buttonColor,
                                          foregroundColor: buttonTextColor,
                                          minimumSize: Size(double.infinity, context.h(6)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(context.w(3.5)),
                                          ),
                                          elevation: isDark ? 0 : 5,
                                          shadowColor: buttonShadowColor,
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
                                          backgroundColor: buttonColor,
                                          foregroundColor: buttonTextColor,
                                          minimumSize: Size(double.infinity, context.h(6)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(context.w(3.5)),
                                          ),
                                          elevation: isDark ? 0 : 5,
                                          shadowColor: buttonShadowColor,
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
                                            Text(
                                              ' Sign Up',
                                              style: TextStyle(
                                                fontFamily: 'Pangram',
                                                fontWeight: FontWeight.w500,
                                                color: cardTextColor,
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
                ),
              ),
            ),
    );
  }
}
