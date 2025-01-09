import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'Providers/moodEntry_provider.dart';
import 'Providers/checkin_provider.dart';
import 'UI/userAuthentication/signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _getCurrentUser(), // Fetch current user UID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return MaterialApp(
            home: SignInScreen(),
          );
        }

        final user = snapshot.data;
        final userID = user?.uid ?? '';

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => MoodEntryProvider(userID: userID),
            ),
            ChangeNotifierProvider(
              create: (context) => CheckInProvider(userID: userID),
            ),
          ],
          child: MaterialApp(
            home: SignInScreen(), // or other home screen
          ),
        );
      },
    );
  }

  // Fetch current user
  Future<User?> _getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser;
  }
}
