// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebasebackend/snack_bar_helper.dart';
// import 'package:flutter/material.dart';
//
// class ForgotPasswordScreen extends StatefulWidget {
//   @override
//   _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
// }
//
// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final _emailController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   Future<void> _resetPassword() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await FirebaseAuth.instance.sendPasswordResetEmail(
//           email: _emailController.text.trim(),
//         );
//         showSnackBar(context, 'Password reset email sent!', Colors.green);
//       } on FirebaseAuthException catch (e) {
//         showSnackBar(context, e.message ?? 'Failed to send email', Colors.red);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: RadialGradient(
//             center: Alignment(-0.5, -0.5),
//             radius: 1.8,
//             colors: [
//               Color(0xFFF3EAF8),
//               Color(0xFFFF92A9),
//               Color(0xFFCCEFFF),
//             ],
//             stops: [0, 0.4, 0.9],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               AppBar(
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 title: Padding(
//                   padding: const EdgeInsets.only(top: 25.0, left:40),
//                   child: const Text(
//                     'Change Password',
//                     style: TextStyle(
//                       fontFamily: 'Pangram',
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white, // Adjusted for visibility
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 150),
//
//               Container(
//                 height: 250,
//                 width: 350,
//                 decoration: BoxDecoration(color: Colors.white,
//                   borderRadius: BorderRadius.circular(20.0),),
//
//                 child:  Padding(
//                   padding: const EdgeInsets.all(25.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextFormField(
//                           controller: _emailController,
//                           decoration: InputDecoration(hintText: 'Enter your Email', prefixIcon: Icon(Icons.email, size: 20,),),
//                           validator: (value) {
//                             if (value == null || !value.contains('@')) {
//                               return 'Please enter a valid email';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 30),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xB2C9FAFB),
//                             foregroundColor: Colors.black, // Text color
//                             minimumSize: const Size(double.infinity, 50), // Wider button
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0), // Slightly rounded edges
//                             ),
//
//                             elevation: 5, // Adds shadow
//                             shadowColor: Color(0xFFCCEFFF),
//                           ),
//                           onPressed: _resetPassword,
//                           child: const Text('Reset Password'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Padding(
//               //   padding: const EdgeInsets.all(25.0),
//               //   child: Form(
//               //     key: _formKey,
//               //     child: Column(
//               //       mainAxisAlignment: MainAxisAlignment.center,
//               //       children: [
//               //         TextFormField(
//               //           controller: _emailController,
//               //           decoration: InputDecoration(hintText: 'Email'),
//               //           validator: (value) {
//               //             if (value == null || !value.contains('@')) {
//               //               return 'Please enter a valid email';
//               //             }
//               //             return null;
//               //           },
//               //         ),
//               //         const SizedBox(height: 20),
//               //         ElevatedButton(
//               //           style: ElevatedButton.styleFrom(
//               //             backgroundColor: Color(0xFFF3EAF8), // Set your desired background color
//               //             foregroundColor: Colors.black,)
//               //           ,
//               //           onPressed: _resetPassword,
//               //           child: const Text('Reset Password'),
//               //         ),
//               //       ],
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/snack_bar_helper.dart';
import '../widgets/responsive_extension.dart';
import '../../theme/app_colors.dart';
import '../../utils/error_parser.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
        if (mounted) {
          showSnackBar(context, 'Password reset email sent!', Color(0xFF8B4CFC));
        }
      } catch (e) {
        if (mounted) {
          showSnackBar(context, ErrorParser.getFriendlyMessage(e), Color(0xFF8B4CFC));
        }
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

    // Text field styles
    final inputFillColor = isDark ? const Color(0xFF140E1B) : Colors.white;
    final inputBorderColor = isDark ? Colors.transparent : Colors.grey.shade300;

    // Button style
    final buttonColor = isDark ? AppColors.primary : const Color(0xB2C9FAFB);
    final buttonTextColor = isDark ? Colors.white : Colors.black;
    final buttonShadowColor = isDark ? Colors.transparent : const Color(0xFFCCEFFF);

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: cardTextColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Padding(
                    padding: EdgeInsets.only(top: context.h(3)),
                    child: Center(
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                          fontFamily: 'Pangram',
                          fontWeight: FontWeight.w600,
                          color: cardTextColor,
                        ),
                      ),
                    ),
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
                              hintText: 'Enter your Email',
                              hintStyle: TextStyle(
                                fontFamily: 'Pangram',
                                fontWeight: FontWeight.w500,
                                color: cardSubtitleColor,
                              ),
                              prefixIcon: Icon(Icons.email, size: context.w(5), color: cardSubtitleColor),
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
                              if (value == null || !value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: context.h(3.5)),
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
                            onPressed: _resetPassword,
                            child: const Text(
                              'Reset Password',
                              style: TextStyle(
                                fontFamily: 'Pangram',
                                fontWeight: FontWeight.w500,
                              ),
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
    );
  }
}
