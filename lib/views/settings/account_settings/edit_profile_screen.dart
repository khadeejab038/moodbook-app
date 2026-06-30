import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import '../../../models/database/user_database.dart';
import '../../../models/user.dart' as model;
import '../../../views/widgets/responsive_extension.dart';
import '../../../views/widgets/snack_bar_helper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../../utils/error_parser.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String currentEmail = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      model.User? currentUser = await UserDatabase.fetchCurrentUser();
      if (currentUser != null && mounted) {
        setState(() {
          name = currentUser.name;
          email = currentUser.email;
          currentEmail = currentUser.email;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, ErrorParser.getFriendlyMessage(e));
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Function to prompt user for their password (necessary for re-authentication)
  Future<String?> _promptForPassword() async {
    String? password = '';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          title: Text('Enter Password', style: AppTextStyles.heading2.copyWith(color: textColor)),
          content: TextField(
            obscureText: true,
            style: AppTextStyles.body.copyWith(color: textColor),
            onChanged: (value) {
              password = value;
            },
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: AppTextStyles.inputHint.copyWith(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: AppTextStyles.link.copyWith(color: AppColors.primary)),
              onPressed: () {
                Navigator.of(context).pop(null); // return null explicitly
              },
            ),
            TextButton(
              child: Text('Submit', style: AppTextStyles.link.copyWith(color: AppColors.primary)),
              onPressed: () {
                Navigator.of(context).pop(password);
              },
            ),
          ],
        );
      },
    );
    return password;
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;

        if (firebaseUser != null && email != currentEmail) {
          String? userPassword = await _promptForPassword();

          if (userPassword == null || userPassword.isEmpty) {
            if (mounted) {
              showSnackBar(context, 'Password is required to change your email.');
            }
            return;
          }

          final auth.AuthCredential credential = auth.EmailAuthProvider.credential(
            email: currentEmail,
            password: userPassword,
          );
          await firebaseUser.reauthenticateWithCredential(credential);
          await firebaseUser.updateEmail(email);
        }

        model.User? currentUser = await UserDatabase.fetchCurrentUser();
        if (currentUser != null) {
          currentUser.name = name;
          currentUser.email = email;
          await UserDatabase.updateUserInFirestore(currentUser.userID, currentUser);

          if (mounted) {
            showSnackBar(context, 'Profile updated successfully!');
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          showSnackBar(context, ErrorParser.getFriendlyMessage(e));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final containerBg = isDark ? AppColors.surfaceDark : Colors.white;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.addMoodGradientDark : AppColors.addMoodGradient,
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.w(5), vertical: context.h(1.2)),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      BackButton(
                        color: textColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: context.w(20)),
                      Text(
                        "Edit Profile",
                        style: AppTextStyles.pageTitle.copyWith(
                          color: textColor,
                          fontSize: context.w(5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(8.75)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Name",
                      style: AppTextStyles.bodyBold.copyWith(
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                  ),
                  SizedBox(height: context.h(1.2)),
                  TextFormField(
                    initialValue: name,
                    style: AppTextStyles.body.copyWith(color: textColor),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Name cannot be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      hintStyle: AppTextStyles.inputHint.copyWith(color: subtitleColor),
                      filled: true,
                      fillColor: containerBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.w(2.5)),
                        borderSide: isDark ? BorderSide(color: Colors.grey.shade800) : const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.w(2.5)),
                        borderSide: isDark ? BorderSide(color: Colors.grey.shade800) : const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.w(2.5)),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: context.h(2.5)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email",
                      style: AppTextStyles.bodyBold.copyWith(
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                  ),
                  SizedBox(height: context.h(1.2)),
                  TextFormField(
                    initialValue: email,
                    style: AppTextStyles.body.copyWith(color: textColor),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email cannot be empty";
                      }
                      if (!RegExp(r"^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$").hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      hintStyle: AppTextStyles.inputHint.copyWith(color: subtitleColor),
                      filled: true,
                      fillColor: containerBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.w(2.5)),
                        borderSide: isDark ? BorderSide(color: Colors.grey.shade800) : const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.w(2.5)),
                        borderSide: isDark ? BorderSide(color: Colors.grey.shade800) : const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.w(2.5)),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: context.h(3.5)),
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
                    onPressed: _updateUserProfile,
                    child: Text('Update Profile', style: AppTextStyles.button.copyWith(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
