import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../widgets/snack_bar_helper.dart';
import '../../user_authentication/signin_screen.dart';
import '../../../../utils/error_parser.dart';

class AccountSettings {
  static Future<void> handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Ensure Google Sign-In is disconnected to allow account switching next time
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, ErrorParser.getFriendlyMessage(e), Color(0xFF8B4CFC));
      }
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
