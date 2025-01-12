import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'Providers/moodEntry_provider.dart';
import 'Providers/checkin_provider.dart';
import 'UI/home/home_screen.dart';
import 'UI/userAuthentication/signin_screen.dart'; // Import your SignInScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide default empty providers here
        ChangeNotifierProvider(create: (context) => MoodEntryProvider(userID: '')),
        ChangeNotifierProvider(create: (context) => CheckInProvider(userID: '')),
      ],
      child: MaterialApp(
        home: AuthWrapper(), // Wrapper to handle auth state
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen to auth state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show a loading spinner while checking authentication state
        }

        if (snapshot.hasData) {
          // User is signed in
          final userID = snapshot.data!.uid;

          // Now that we have the userID, update the providers with the actual user ID
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => MoodEntryProvider(userID: userID)),
              ChangeNotifierProvider(create: (context) => CheckInProvider(userID: userID)),
            ],
            child: HomeScreen(), // Navigate to the Home Screen
          );
        }

        // User is not signed in
        return SignInScreen(); // Show the Sign-In Screen
      },
    );
  }
}
