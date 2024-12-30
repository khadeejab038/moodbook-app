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
import '../../Utils/snack_bar_helper.dart';

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
        showSnackBar(context, 'Password reset email sent!', Colors.green);
      } on FirebaseAuthException catch (e) {
        showSnackBar(context, e.message ?? 'Failed to send email', Colors.red);
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
                height: 250,
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
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter your Email',
                            prefixIcon: Icon(Icons.email, size: 20),
                          ),
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
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
                          onPressed: _resetPassword,
                          child: const Text('Reset Password'),
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
