import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/moodEntry_provider.dart';
import 'UI/splashscreen.dart';
import 'UI/userAuthentication/signin_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MoodEntryProvider(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        home: SignInScreen(),
      ),
    );
  }
}

