import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebackend/UI/editprof.dart';
import 'package:flutter/material.dart';

import '../../Utils/snack_bar_helper.dart';
import '../../Widgets/bottom_nav_bar.dart';
import '../userAuthentication/signin_screen.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Prevent back button
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'Pangram',
                fontWeight: FontWeight.bold,
                color: Color(0xFF100F11),
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFF100F11)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xAAC7DFFF), // #BACFFF with 67% opacity
              Color(0xFFFFCEB7), // #FFCEB7 with 100% opacity
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Account Settings
            _buildSectionTitle('Account Settings'),
            _buildSettingsTile(
              title: 'Profile Management',
              subtitle: 'Edit name, email, and profile picture',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProf()),
              ),
            ),
            _buildSettingsTile(
              title: 'Change Password',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
              ),
            ),

            _buildSettingsTile(
              title: 'Logout',
              onTap: () => _handleLogout(context),
            ),
            SizedBox(height: 16),

            // App Preferences
            _buildSectionTitle('App Preferences'),
            _buildSwitchTile(
              title: 'Dark Mode',
              value: false, // Replace with a variable to track state
              onChanged: (value) => _toggleTheme(context, value),
            ),
            _buildSettingsTile(
              title: 'Notification Settings',
              subtitle: 'Set reminder preferences',
              onTap: () => _navigateTo(context, '/notificationSettings'),
            ),
            SizedBox(height: 16),

            // Data Management
            _buildSectionTitle('Data Management'),
            _buildSettingsTile(
              title: 'Export Data',
              onTap: () => _exportData(context),
            ),
            _buildSettingsTile(
              title: 'Delete Account',
              onTap: () => _confirmDeleteAccount(context),
            ),
            _buildSettingsTile(
              title: 'Clear Mood Logs',
              onTap: () => _clearMoodLogs(context),
            ),
            SizedBox(height: 16),

            // Support and Feedback
            _buildSectionTitle('Support and Feedback'),
            _buildSettingsTile(
              title: 'Help Center',
              onTap: () => _navigateTo(context, '/helpCenter'),
            ),
            _buildSettingsTile(
              title: 'Contact Support',
              onTap: () => _navigateTo(context, '/contactSupport'),
            ),
            _buildSettingsTile(
              title: 'Feedback',
              onTap: () => _navigateTo(context, '/feedback'),
            ),
            SizedBox(height: 16),

            // About
            _buildSectionTitle('About'),
            _buildSettingsTile(
              title: 'About MoodBook',
              subtitle: 'Version 1.0.0',
              onTap: () => _showAboutDialog(context),
            ),
            SizedBox(height: 16),

            // Legal
            _buildSectionTitle('Legal'),
            _buildSettingsTile(
              title: 'Privacy Policy',
              onTap: () => _openWebPage('https://moodbook.com/privacy'),
            ),
            _buildSettingsTile(
              title: 'Terms of Service',
              onTap: () => _openWebPage('https://moodbook.com/terms'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontFamily: 'Pangram',
          color: Color(0xFF100F11),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Pangram',
          fontWeight: FontWeight.normal,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Pangram',
                color: Color(0xFF100F11).withOpacity(0.74),
              ),
            )
          : null,
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Pangram',
          color: Color(0xFF100F11),
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  // Helper Functions
  void _navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  void _toggleTheme(BuildContext context, bool value) {
    // Implement theme toggle logic
  }

  void _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      showSnackBar(context, 'Logged out successfully!', Color(0xFF8B4CFC));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } catch (e) {
      showSnackBar(context, 'Logout failed', Colors.red);
    }
  }


  void _exportData(BuildContext context) {
    // Implement data export functionality
  }

  void _confirmDeleteAccount(BuildContext context) {
    // Implement account deletion confirmation
  }

  void _clearMoodLogs(BuildContext context) {
    // Implement clearing mood logs
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'MoodBook',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 MoodBook Inc. All rights reserved.',
    );
  }

  void _openWebPage(String url) {
    // Open a web page using a package like url_launcher
  }
}




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

        showSnackBar(context, 'Password changed successfully!', Colors.green);

        // Navigate back after successful password change
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        showSnackBar(context, e.message ?? 'Password change failed', Colors.red);
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
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 25.0, left: 40),
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
              const SizedBox(height: 150),
              Container(
                height: 350,
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
                        // Current Password Input
                        TextFormField(
                          controller: _currentPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Current Password',
                            prefixIcon: Icon(Icons.lock, size: 20),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your current password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // New Password Input
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'New Password',
                            prefixIcon: Icon(Icons.lock, size: 20),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Confirm New Password Input
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Confirm New Password',
                            prefixIcon: Icon(Icons.lock, size: 20),
                          ),
                          validator: (value) {
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Change Password Button
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
    );
  }
}
