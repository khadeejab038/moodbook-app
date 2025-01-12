// import 'package:firebasebackend/UI/userAuthentication/signin_screen.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:flutter/services.dart';
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//     // Set immersive mode
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
//
//     Future.delayed(Duration(seconds: 10), () {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => SignInScreen()),
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     // Restore manual UI overlays when splash screen is disposed
//     SystemChrome.setEnabledSystemUIMode(
//       SystemUiMode.manual,
//       overlays: SystemUiOverlay.values,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.blue,
//         width:  double.infinity,// Background color
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Icon(
//               //   Icons.flash_on, // Example icon
//               //   size: 400.0,
//               //   color: Colors.white,
//               // ),
//               Text("splash", style: TextStyle(fontSize: 27),),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebasebackend/UI/userAuthentication/signin_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Set immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    });
  }

  @override
  void dispose() {
    // Restore manual UI overlays when splash screen is disposed
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            "Splash Screen",
            style: TextStyle(
              fontSize: 27,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
