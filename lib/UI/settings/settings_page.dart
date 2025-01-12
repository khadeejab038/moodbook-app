import 'package:firebasebackend/UI/settings/accountSettings/edit_profile_screen.dart';
import 'package:firebasebackend/UI/settings/accountSettings/account_settings.dart';
import 'package:firebasebackend/UI/settings/appPreferences/notifications_settings_page.dart';
import 'package:firebasebackend/UI/settings/appPreferences/theme_settings.dart';
import 'package:firebasebackend/UI/settings/supportAndFeedback/contact_support_page.dart';
import 'package:firebasebackend/UI/settings/supportAndFeedback/feedback_page.dart';
import 'package:flutter/material.dart';
import '../../Widgets/bottom_nav_bar.dart';
import 'about/about.dart';
import 'accountSettings/change_password_screen.dart';
import 'dataManagement/data_management.dart';

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
              subtitle: 'Edit name, email, and avatar',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile()),
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
              onTap: () => AccountSettings.handleLogout(context),
            ),

            _buildSettingsTile(
              title: 'Delete Account',
              onTap: () => AccountSettings.confirmDeleteAccount(context),
            ),

            SizedBox(height: 16),

            // App Preferences
            _buildSectionTitle('App Preferences'),
            _buildSwitchTile(
              title: 'Dark Mode',
              value: false,
              onChanged: (value) => ThemeSettings.toggleTheme(context, value),
            ),
            _buildSettingsTile(
              title: 'Notification Settings',
              subtitle: 'Set reminder preferences',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsSettingsPage()),
              ),
            ),
            SizedBox(height: 16),

            // Data Management
            _buildSectionTitle('Data Management'),
            _buildSettingsTile(
              title: 'Export Data',
              onTap: () => DataManagement.exportData(context),
            ),
            _buildSettingsTile(
              title: 'Clear Mood Logs',
              onTap: () => DataManagement.clearMoodLogs(context),
            ),
            SizedBox(height: 16),

            // Support and Feedback
            _buildSectionTitle('Support and Feedback'),
            _buildSettingsTile(
              title: 'Help Center',
              onTap: () => _openWebPage('https://moodbook.com/helpCenter'),
            ),
            _buildSettingsTile(
              title: 'Contact Support',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactSupportPage()),
              ),
            ),
            _buildSettingsTile(
              title: 'Feedback',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackPage()),
              ),
            ),
            SizedBox(height: 16),

            // About
            _buildSectionTitle('About'),
            _buildSettingsTile(
              title: 'About MoodBook',
              subtitle: 'Version 1.0.0',
              onTap: () => About.showCustomAboutDialog(context),
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

  void _openWebPage(String url) {
    // Open a web page using a package like url_launcher
  }
}
