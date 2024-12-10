import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebackend/snack_bar_helper.dart';
import 'package:flutter/material.dart';

import 'signin_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                showSnackBar(context, 'Logged out successfully!', Colors.green);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              } catch (e) {
                showSnackBar(context, 'Logout failed', Colors.red);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to the Home Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
