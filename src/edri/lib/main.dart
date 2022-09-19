import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    ThemeData darkTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange.shade900,
        brightness: Brightness.dark,
      ),
    );
    darkTheme = darkTheme.copyWith(scaffoldBackgroundColor: Colors.black);
    // darkTheme = darkTheme.copyWith(tabBarTheme:TabBarTheme());
    ThemeData lightTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange.shade700,
        brightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: darkTheme,
      theme: lightTheme,
      home: (auth.currentUser == null) ? const LoginScreen() : const SurveyScreen(),
      routes: {
        "/login": (context) => const LoginScreen(),
        "/survey": (context) => const SurveyScreen(),
      },
    );
  }
}
