import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../utils/error_parser.dart';
import '../../utils/network_helper.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';
import '../user_authentication/signin_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/snack_bar_helper.dart';
import '../widgets/responsive_extension.dart';
import 'about/about.dart';
import 'account_settings/change_password_screen.dart';
import 'account_settings/edit_profile_screen.dart';
import 'account_settings/account_settings.dart';
import 'app_preferences/notifications_settings_screen.dart';
import 'data_management/data_management.dart';
import 'support_and_feedback/contact_support_page.dart';
import 'support_and_feedback/feedback_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.pageGradientDark : AppColors.pageGradientLight,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(context.w(4), context.h(8.75), context.w(4), context.w(4)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Settings',
                  style: AppTextStyles.pageTitle.copyWith(
                    color: textColor,
                    fontSize: context.w(5),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(context.w(4)),
                children: [
                  // Account Settings
                  _buildSectionTitle(context, 'Account Settings', textColor),
                  _buildSettingsTile(
                    context: context,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    title: 'Profile Management',
                    subtitle: 'Edit name and email',
                    onTap: () {
                      final user = FirebaseAuth.instance.currentUser;
                      final isGoogleUser = user != null &&
                          user.providerData.any((u) => u.providerId == 'google.com');
                      if (isGoogleUser) {
                        showSnackBar(context, 'Profile editing is not available for Google accounts.', AppColors.primary);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfile()),
                        );
                      }
                    },
                  ),
                  _buildSettingsTile(
                    context: context,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    title: 'Change Password',
                    onTap: () {
                      final user = FirebaseAuth.instance.currentUser;
                      final isGoogleUser = user != null &&
                          user.providerData.any((u) => u.providerId == 'google.com');
                      if (isGoogleUser) {
                        showSnackBar(context, 'Password change is not available for Google accounts.', AppColors.primary);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                        );
                      }
                    },
                  ),
                  _buildSettingsTile(
                    context: context,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    title: 'Logout',
                    onTap: () => AccountSettings.handleLogout(context),
                  ),
                  _buildSettingsTile(
                    context: context,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    title: 'Delete Account',
                    onTap: () => _confirmDeleteAccount(context),
                  ),

                  SizedBox(height: context.h(2)),

                  // App Preferences
                  _buildSectionTitle(context, 'App Preferences', textColor),
                  _buildSwitchTile(
                    textColor: textColor,
                    title: 'Dark Mode',
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (value) => themeProvider.setDark(value),
                  ),
                  _buildSettingsTile(
                    context: context,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    title: 'Notification Settings',
                    subtitle: 'Set reminder preferences',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationsSettingsPage()),
                    ),
                  ),
                  SizedBox(height: context.h(2)),

                  // Data Management
                  _buildSectionTitle(context, 'Data Management', textColor),
                  _buildSettingsTile(
                    context: context,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    title: 'Export Data',
                    onTap: () => DataManagement.exportData(context),
                  ),
                  _buildSettingsTile(
                    context: context,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    title: 'Clear Mood Logs',
                    onTap: () => DataManagement.clearMoodLogs(context),
                  ),
                  SizedBox(height: context.h(2)),

                  // Support and Feedback
                  _buildSectionTitle(context, 'Support and Feedback', textColor),
                  _buildSettingsTile(
                    context: context,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    title: 'Help Center',
                    onTap: () => _openWebPage('https://moodbook.com/helpCenter'),
                  ),
                  _buildSettingsTile(
                    context: context,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    title: 'Contact Support',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactSupportPage()),
                    ),
                  ),
                  _buildSettingsTile(
                    context: context,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    title: 'Feedback',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedbackPage()),
                    ),
                  ),
                  SizedBox(height: context.h(2)),

                  // About
                  _buildSectionTitle(context, 'About', textColor),
                  _buildSettingsTile(
                    context: context,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    title: 'About MoodBook',
                    subtitle: 'Version 1.0.0',
                    onTap: () => About.showCustomAboutDialog(context),
                  ),
                  SizedBox(height: context.h(2)),

                  // Legal
                  _buildSectionTitle(context, 'Legal', textColor),
                  _buildSettingsTile(
                    context: context,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    title: 'Privacy Policy',
                    onTap: () => _openWebPage('https://moodbook.com/privacy'),
                  ),
                  _buildSettingsTile(
                    context: context,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    title: 'Terms of Service',
                    onTap: () => _openWebPage('https://moodbook.com/terms'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.h(1.5)),
      child: Text(
        title,
        style: AppTextStyles.settingsSection.copyWith(
          fontSize: context.w(4.5),
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required Color textColor,
    required Color subtitleColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: AppTextStyles.settingsTile.copyWith(color: textColor),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: AppTextStyles.settingsTile.copyWith(
          color: subtitleColor,
        ),
      )
          : null,
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios, size: context.w(4), color: subtitleColor),
    );
  }

  Widget _buildSwitchTile({
    required Color textColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: AppTextStyles.settingsTile.copyWith(color: textColor),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  void _openWebPage(String url) {
    // Open a web page
  }
}

Future<void> deleteUserAccount(BuildContext pageContext) async {
  // Show loading spinner
  showDialog(
    context: pageContext,
    barrierDismissible: false,
    builder: (spinnerContext) => const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(child: CircularProgressIndicator()),
    ),
  );

  try {
    if (!await NetworkHelper.isConnected()) {
      if (pageContext.mounted) {
        Navigator.of(pageContext).pop(); // Dismiss spinner
        showSnackBar(pageContext, 'No internet connection. Account deletion requires an active network.');
      }
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (pageContext.mounted) {
        Navigator.of(pageContext).pop(); // Dismiss spinner
        showSnackBar(pageContext, 'No user is signed in.');
      }
      return;
    }

    String userId = user.uid;

    // Fetch and delete all user mood entries in chunked batches (max 500 per batch)
    QuerySnapshot moodEntries = await FirebaseFirestore.instance
        .collection('mood_entries')
        .where('userId', isEqualTo: userId)
        .get();

    var batch = FirebaseFirestore.instance.batch();
    int count = 0;

    batch.delete(FirebaseFirestore.instance.collection('users').doc(userId));
    count++;

    for (var doc in moodEntries.docs) {
      batch.delete(doc.reference);
      count++;
      if (count == 500) {
        await batch.commit();
        batch = FirebaseFirestore.instance.batch();
        count = 0;
      }
    }
    if (count > 0) {
      await batch.commit();
    }

    // Step 2: Delete the user account from Firebase Authentication
    await user.delete();
    print('User account and associated data successfully deleted.');

    if (pageContext.mounted) {
      Navigator.of(pageContext).pop(); // Dismiss spinner
      showSnackBar(pageContext, 'Account deleted successfully.');
    }

    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut(); // Clean up Google credentials

    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );

  } catch (e) {
    if (pageContext.mounted) {
      Navigator.of(pageContext).pop(); // Dismiss spinner
      showSnackBar(pageContext, ErrorParser.getFriendlyMessage(e));
    }
    print('Error while deleting user account: $e');
  }
}

// Confirm Delete Account Dialog
void _confirmDeleteAccount(BuildContext pageContext) {
  final TextEditingController passwordController = TextEditingController();
  final isDark = Theme.of(pageContext).brightness == Brightness.dark;
  final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  final currentUser = FirebaseAuth.instance.currentUser;
  final isGoogleUser = currentUser != null &&
      currentUser.providerData.any((u) => u.providerId == 'google.com');

  showDialog(
    context: pageContext,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Text('Delete Account', style: AppTextStyles.heading2.copyWith(color: textColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete your account? This action cannot be undone.',
                style: AppTextStyles.body.copyWith(color: textColor)),
            if (!isGoogleUser) ...[
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                style: AppTextStyles.body.copyWith(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Enter your password',
                  labelStyle: AppTextStyles.inputLabel.copyWith(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                  hintText: 'Password',
                  hintStyle: AppTextStyles.inputHint.copyWith(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
                  filled: true,
                  fillColor: isDark ? AppColors.cardDark : Colors.grey.shade100,
                  border: const OutlineInputBorder(),
                ),
              ),
            ] else ...[
              const SizedBox(height: 15),
              Text(
                'To delete your account, we need to re-authenticate with your Google Account first.',
                style: AppTextStyles.body.copyWith(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: AppTextStyles.link.copyWith(color: AppColors.primary)),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          TextButton(
            child: Text(isGoogleUser ? 'Re-authenticate' : 'Delete', style: AppTextStyles.link.copyWith(color: AppColors.error)),
            onPressed: () async {
              Navigator.of(dialogContext).pop(); // Close the dialog

              if (!await NetworkHelper.isConnected()) {
                if (pageContext.mounted) {
                  showSnackBar(pageContext, 'No internet connection. Account deletion requires an active network.');
                }
                return;
              }

              if (currentUser != null) {
                try {
                  if (isGoogleUser) {
                    final GoogleSignIn googleSignIn = GoogleSignIn();
                    final GoogleSignInAccount? googleUser = await googleSignIn.signInSilently() ?? await googleSignIn.signIn();
                    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

                    if (googleAuth != null) {
                      final AuthCredential credential = GoogleAuthProvider.credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken,
                      );
                      await currentUser.reauthenticateWithCredential(credential);
                      if (pageContext.mounted) {
                        await deleteUserAccount(pageContext);
                      }
                    } else {
                      if (pageContext.mounted) {
                        showSnackBar(pageContext, 'Google re-authentication canceled.');
                      }
                    }
                  } else {
                    final String password = passwordController.text.trim();

                    if (password.isNotEmpty) {
                      await currentUser.reauthenticateWithCredential(
                        EmailAuthProvider.credential(
                          email: currentUser.email!,
                          password: password,
                        ),
                      );
                      if (pageContext.mounted) {
                        await deleteUserAccount(pageContext);
                      }
                    } else {
                      if (pageContext.mounted) {
                        showSnackBar(pageContext, 'Please enter your password to proceed.');
                      }
                    }
                  }
                } catch (e) {
                  if (pageContext.mounted) {
                    showSnackBar(pageContext, ErrorParser.getFriendlyMessage(e));
                  }
                }
              }
            },
          ),
        ],
      );
    },
  );
}