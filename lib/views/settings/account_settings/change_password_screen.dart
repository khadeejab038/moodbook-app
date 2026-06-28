import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../widgets/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import '../../../views/widgets/responsive_extension.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        // Re-authenticate the user
        AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: _currentPasswordController.text.trim(),
        );

        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(_newPasswordController.text.trim());

        showSnackBar(context, 'Password changed successfully!', Color(0xFF8B4CFC));

        // Navigate back after successful password change
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        showSnackBar(context, e.message ?? 'Password change failed', Color(0xFF8B4CFC));
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
                    icon: Icon(Icons.arrow_back, color: Colors.white), // White back button
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                  ),
                  title: Padding(
                    padding: EdgeInsets.only(top: context.h(3), left: context.w(10)),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                        fontFamily: 'Pangram',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.h(3.5)),
                Container(
                  width: context.w(85).clamp(300.0, 360.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(context.w(5)),
                  ),
                child: Padding(
                  padding: EdgeInsets.all(context.w(6.25)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Current Password Input
                        TextFormField(
                          controller: _currentPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Current Password',
                            prefixIcon: Icon(Icons.lock, size: context.w(5)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your current password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: context.h(2.5)),

                        // New Password Input
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'New Password',
                            prefixIcon: Icon(Icons.lock, size: context.w(5)),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: context.h(2.5)),

                        // Confirm New Password Input
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Confirm New Password',
                            prefixIcon: Icon(Icons.lock, size: context.w(5)),
                          ),
                          validator: (value) {
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: context.h(3.5)),

                        // Change Password Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xB2C9FAFB),
                            foregroundColor: Colors.black,
                            minimumSize: Size(double.infinity, context.h(6)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(context.w(3.75)),
                            ),
                            elevation: 5,
                            shadowColor: const Color(0xFFCCEFFF),
                          ),
                          onPressed: _changePassword,
                          child: const Text('Change Password'),
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
