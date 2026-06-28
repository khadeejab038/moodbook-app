import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'controllers/mood_entry_controller.dart';
import 'controllers/check_in_controller.dart';
import 'views/home/home_screen.dart';
import 'views/user_authentication/signin_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MoodEntryController(userID: '')),
        ChangeNotifierProvider(create: (_) => CheckInController(userID: '')),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'MoodBook',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            home: AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          final userID = snapshot.data!.uid;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => MoodEntryController(userID: userID)),
              ChangeNotifierProvider(create: (_) => CheckInController(userID: userID)),
            ],
            child: HomeScreen(),
          );
        }

        return SignInScreen();
      },
    );
  }
}
