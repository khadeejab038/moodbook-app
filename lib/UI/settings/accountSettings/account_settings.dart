import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../Utils/snack_bar_helper.dart';
import '../../userAuthentication/signin_screen.dart';

class AccountSettings {
  static Future<void> handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      showSnackBar(context, 'Logged out successfully!', Color(0xFF8B4CFC));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } catch (e) {
      showSnackBar(context, 'Logout failed', Color(0xFF8B4CFC));
    }
  }

  static void confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text(
          'Are you sure you want to delete your account? This action is irreversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement account deletion logic here
              Navigator.of(context).pop();
              showSnackBar(context, 'Account deleted successfully!', Color(0xFF8B4CFC));
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
