import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'stats_page.dart';
import 'history_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              onTap: () => _navigateTo(context, '/profileManagement'),
            ),
            _buildSettingsTile(
              title: 'Change Password',
              onTap: () => _navigateTo(context, '/changePassword'),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 0:
               Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => StatsPage(),
                ),
              );
              break;
            case 2:
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                ),
                builder: (BuildContext context) {
                  return AddMoodModal();
                },
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(),
                ),
              );
              break;
            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), label: "Add Mood"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
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

  void _handleLogout(BuildContext context) {
    // Implement logout logic
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
