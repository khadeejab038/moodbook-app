import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import '../../../views/widgets/responsive_extension.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

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

        showSnackBar(context, 'Password changed successfully!', AppColors.primary);

        // Navigate back after successful password change
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        showSnackBar(context, e.message ?? 'Password change failed', AppColors.primary);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.signInGradientDark : AppColors.signInGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Padding(
                    padding: EdgeInsets.only(top: context.h(3), left: context.w(10)),
                    child: Text(
                      'Change Password',
                      style: AppTextStyles.pageTitle.copyWith(
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.h(3.5)),
                Container(
                  width: context.w(85).clamp(300.0, 360.0),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(context.w(5)),
                    border: isDark ? Border.all(color: Colors.grey.shade800) : null,
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
                            style: AppTextStyles.body.copyWith(color: textColor),
                            decoration: InputDecoration(
                              hintText: 'Current Password',
                              hintStyle: AppTextStyles.inputHint.copyWith(color: subtitleColor),
                              prefixIcon: Icon(Icons.lock, size: context.w(5), color: subtitleColor),
                              filled: true,
                              fillColor: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(context.w(3.5))),
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
                            style: AppTextStyles.body.copyWith(color: textColor),
                            decoration: InputDecoration(
                              hintText: 'New Password',
                              hintStyle: AppTextStyles.inputHint.copyWith(color: subtitleColor),
                              prefixIcon: Icon(Icons.lock, size: context.w(5), color: subtitleColor),
                              filled: true,
                              fillColor: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(context.w(3.5))),
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
                            style: AppTextStyles.body.copyWith(color: textColor),
                            decoration: InputDecoration(
                              hintText: 'Confirm New Password',
                              hintStyle: AppTextStyles.inputHint.copyWith(color: subtitleColor),
                              prefixIcon: Icon(Icons.lock, size: context.w(5), color: subtitleColor),
                              filled: true,
                              fillColor: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(context.w(3.5))),
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
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, context.h(6)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(context.w(3.75)),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _changePassword,
                            child: Text('Change Password', style: AppTextStyles.button.copyWith(color: Colors.white)),
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
