import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/database/user_database.dart';
import '../../theme/app_colors.dart';
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
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Register user and save data to Firestore
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
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
          AppUser.User newUser = AppUser.User(
            userID: user.uid,
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            createdAt: DateTime.now(),
          );

          // Use UserDatabase to save the user to Firestore
          await UserDatabase.saveUserToFirestore(newUser);

          // Show success message
          showSnackBar(context, 'Sign-up successful!', AppColors.primary);

          // Navigate to home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Handle errors during registration
        showSnackBar(context, e.message ?? 'Sign-up failed', AppColors.primary);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        showSnackBar(context, 'Sign-up failed: $e', AppColors.primary);
        setState(() {
          _isLoading = false;
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
      body: _isLoading
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
                              'Create Account',
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
                            SizedBox(height: context.h(3.5)),
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
                                padding: EdgeInsets.all(context.w(6.5)),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Name input field
                                      TextFormField(
                                        controller: _nameController,
                                        style: TextStyle(
                                          fontFamily: 'Pangram',
                                          fontWeight: FontWeight.w500,
                                          color: cardTextColor,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: inputFillColor,
                                          hintText: 'Enter your name',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Pangram',
                                            fontWeight: FontWeight.w500,
                                            color: cardSubtitleColor,
                                          ),
                                          helperText: 'Your name will show on the home screen',
                                          helperStyle: TextStyle(
                                            fontFamily: 'Pangram',
                                            fontSize: 11,
                                            color: helperTextColor,
                                          ),
                                          prefixIcon: Icon(Icons.person_outline, size: context.w(5), color: cardSubtitleColor),
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
                                            return 'Please enter your name';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: context.h(2.5)),
                                      // Email input field
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
                                          hintText: 'Enter your email',
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
                                      SizedBox(height: context.h(2.5)),
                                      // Password input field
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
                                          hintText: 'Enter your password',
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
                                            return 'Please enter a password';
                                          }
                                          if (value.length < 6) {
                                            return 'Password must be at least 6 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: context.h(2.5)),
                                      // Confirm Password input field
                                      TextFormField(
                                        controller: _confirmPasswordController,
                                        style: TextStyle(
                                          fontFamily: 'Pangram',
                                          fontWeight: FontWeight.w500,
                                          color: cardTextColor,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: inputFillColor,
                                          hintText: 'Confirm your password',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Pangram',
                                            fontWeight: FontWeight.w500,
                                            color: cardSubtitleColor,
                                          ),
                                          helperText: 'Re-enter password to confirm',
                                          helperStyle: TextStyle(
                                            fontFamily: 'Pangram',
                                            fontSize: 11,
                                            color: helperTextColor,
                                          ),
                                          prefixIcon: Icon(Icons.lock_outline, size: context.w(5), color: cardSubtitleColor),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                              size: context.w(5),
                                              color: cardSubtitleColor,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureConfirmPassword = !_obscureConfirmPassword;
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
                                        obscureText: _obscureConfirmPassword,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please confirm your password';
                                          }
                                          if (value != _passwordController.text) {
                                            return 'Passwords do not match';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: context.h(3.5)),
                                      // Sign-up button
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
                                        onPressed: _signUp,
                                        child: const Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            fontFamily: 'Pangram',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: context.h(2.5)),
                                      // Back to Sign-in
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Already registered?',
                                              style: TextStyle(
                                                fontFamily: 'Pangram',
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF8B4CFC),
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                            Text(
                                              ' Sign In',
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
